#!/usr/bin/env python3
"""
V-Model XT decision-gate readiness engine.

Reads artifact frontmatter (same parser as validate-artifacts.py) and reports
whether each decision gate G1..G9 is ready, with a list of blocking conditions
when not.

First cut implements G2 (requirements baselined) in detail; G1 and G3..G9 are
present as stubs returning "not implemented yet" so the data shape is stable
for the dashboard.

Output:
    Human-readable summary to stdout (always).
    Machine-readable JSON to --emit-json PATH (optional).
    Patch into dashboard/data/status.json under decision_gates when --patch-status
    is given.

Exit codes:
    0  all evaluated gates are ready (or no gates were requested)
    1  at least one evaluated gate is blocked
    2  invocation problem
"""
from __future__ import annotations

import argparse
import json
import sys
from dataclasses import dataclass, field
from pathlib import Path

# Re-use the validator's parsing layer.
SCRIPT_DIR = Path(__file__).resolve().parent
sys.path.insert(0, str(SCRIPT_DIR))
import importlib.util  # noqa: E402

_spec = importlib.util.spec_from_file_location("validate_artifacts",
                                               SCRIPT_DIR / "validate-artifacts.py")
_va = importlib.util.module_from_spec(_spec)
assert _spec.loader is not None
# Register in sys.modules so dataclass field-type resolution works inside _va.
sys.modules["validate_artifacts"] = _va
_spec.loader.exec_module(_va)

# ---------------------------------------------------------------------------
# Gate definitions
# ---------------------------------------------------------------------------

@dataclass
class GateResult:
    gate: str
    name: str
    ready: bool
    implemented: bool = True
    blockers: list[dict] = field(default_factory=list)
    stats: dict = field(default_factory=dict)

    def add_blocker(self, code: str, message: str, artifact_id: str | None = None) -> None:
        self.blockers.append({"code": code, "message": message, "artifact_id": artifact_id})

    def as_dict(self) -> dict:
        return {
            "gate": self.gate,
            "name": self.name,
            "ready": self.ready,
            "implemented": self.implemented,
            "blockers": self.blockers,
            "stats": self.stats,
        }


GATE_NAMES = {
    "G1": "project_approved",
    "G2": "requirements_baselined",
    "G3": "architecture_defined",
    "G4": "design_completed",
    "G5": "implementation_done",
    "G6": "integration_done",
    "G7": "verification_done",
    "G8": "validation_done",
    "G9": "project_completed",
}


def evaluate_g2(artifacts: list[_va.Artifact]) -> GateResult:
    """G2 — Requirements Baselined.

    Ready when:
      - At least one stakeholder need with status=approved exists.
      - At least one system requirement exists.
      - Every system requirement that is baselined has:
          * non-empty source linking to a stakeholder-need (validator already
            checks link integrity; here we re-check non-empty source).
          * non-empty tests (required by validator's orphan check too, but we
            surface it as a gate-level blocker for clarity).
          * if category=safety: non-empty risks AND safety_class set on the
            corresponding software-requirements that source it.
      - Every system requirement is either baselined OR superseded
        (no draft/reviewed reqs block the gate; they just don't count as
        baselined). The gate is ready when at least one is baselined AND
        no baselined req has open blockers.
      - Software requirements likewise: every baselined SW req has tests
        linked and (if safety) risks + safety_class.
      - No validation errors exist (we re-run the validator inline).
    """
    g = GateResult(gate="G2", name=GATE_NAMES["G2"], ready=True)

    by_id = {a.id: a for a in artifacts}
    stk = [a for a in artifacts if a.type == "stakeholder-need"]
    sysreqs = [a for a in artifacts if a.type == "system-requirement"]
    swreqs = [a for a in artifacts if a.type == "software-requirement"]

    g.stats = {
        "stakeholder_needs_total": len(stk),
        "stakeholder_needs_approved": sum(1 for a in stk if a.status == "approved"),
        "system_requirements_total": len(sysreqs),
        "system_requirements_baselined": sum(1 for a in sysreqs if a.status == "baselined"),
        "software_requirements_total": len(swreqs),
        "software_requirements_baselined": sum(1 for a in swreqs if a.status == "baselined"),
    }

    # Coarse gates
    if g.stats["stakeholder_needs_approved"] == 0:
        g.add_blocker("no-approved-stakeholder-needs",
                      "G2 requires at least one stakeholder-need with status=approved.")
    if g.stats["system_requirements_total"] == 0:
        g.add_blocker("no-system-requirements",
                      "G2 requires at least one system-requirement.")
    if g.stats["system_requirements_baselined"] == 0 and g.stats["system_requirements_total"] > 0:
        g.add_blocker("no-baselined-system-requirements",
                      "G2 requires at least one system-requirement to be baselined.")

    # Per-artifact checks
    for a in sysreqs:
        if a.status != "baselined":
            continue
        fm = a.frontmatter
        if not fm.get("source"):
            g.add_blocker("sysreq-no-source",
                          f"Baselined system-requirement {a.id} has no upstream stakeholder need.",
                          a.id)
        if not fm.get("tests"):
            g.add_blocker("sysreq-no-test",
                          f"Baselined system-requirement {a.id} has no test linked.",
                          a.id)
        if fm.get("category") == "safety" and not fm.get("risks"):
            g.add_blocker("sysreq-safety-no-risk",
                          f"Baselined safety system-requirement {a.id} has no FMEA linked.",
                          a.id)

    for a in swreqs:
        if a.status != "baselined":
            continue
        fm = a.frontmatter
        if not fm.get("source"):
            g.add_blocker("swreq-no-source",
                          f"Baselined software-requirement {a.id} has no upstream system requirement.",
                          a.id)
        if not fm.get("tests"):
            g.add_blocker("swreq-no-test",
                          f"Baselined software-requirement {a.id} has no test linked.",
                          a.id)
        if fm.get("category") == "safety":
            if not fm.get("risks"):
                g.add_blocker("swreq-safety-no-risk",
                              f"Baselined safety software-requirement {a.id} has no FMEA linked.",
                              a.id)
            if not fm.get("safety_class"):
                g.add_blocker("swreq-safety-no-class",
                              f"Baselined safety software-requirement {a.id} has no safety_class set.",
                              a.id)

    # Re-run validator to fold its findings into the gate (errors only).
    report = _va.Report()
    report.artifacts = artifacts
    for a in artifacts:
        _va.validate_artifact(a, by_id, report)
    for f in report.findings:
        if f.severity == "error":
            g.add_blocker(f"validator-{f.code}", f.message, f.artifact_id)

    g.ready = len(g.blockers) == 0
    return g


def evaluate_stub(gate_key: str) -> GateResult:
    return GateResult(
        gate=gate_key,
        name=GATE_NAMES[gate_key],
        ready=False,
        implemented=False,
        blockers=[{"code": "not-implemented",
                   "message": f"Gate {gate_key} readiness logic not yet implemented.",
                   "artifact_id": None}],
    )


GATE_EVALUATORS = {
    "G2": evaluate_g2,
}


# ---------------------------------------------------------------------------
# CLI
# ---------------------------------------------------------------------------

def main(argv: list[str]) -> int:
    p = argparse.ArgumentParser(description="Evaluate V-Model XT decision-gate readiness.")
    p.add_argument("roots", nargs="*", default=["project"],
                   help="One or more directories to scan (default: project).")
    p.add_argument("--gate", action="append", default=None,
                   help="Restrict evaluation to one or more gates (e.g. --gate G2). Default: all.")
    p.add_argument("--emit-json", metavar="PATH",
                   help="Write detailed gate results to PATH.")
    p.add_argument("--patch-status", metavar="PATH",
                   help="Patch decision_gates inside an existing status.json at PATH.")
    p.add_argument("--quiet", action="store_true")
    p.add_argument("--ok-if-empty", action="store_true",
                   help="Exit 0 even when no artifacts are found (useful for fresh templates).")
    args = p.parse_args(argv)

    roots = [Path(r).resolve() for r in args.roots]
    report = _va.Report()
    _va.collect_artifacts(roots, report)
    artifacts = report.artifacts

    gates_to_eval = args.gate or list(GATE_NAMES.keys())
    gates_to_eval = [g.upper() for g in gates_to_eval]
    unknown = [g for g in gates_to_eval if g not in GATE_NAMES]
    if unknown:
        print(f"check-gates: unknown gate(s): {', '.join(unknown)}", file=sys.stderr)
        return 2

    results: list[GateResult] = []
    for gkey in gates_to_eval:
        evaluator = GATE_EVALUATORS.get(gkey)
        results.append(evaluator(artifacts) if evaluator else evaluate_stub(gkey))

    if not args.quiet:
        print("V-Model XT Gate Readiness")
        print("=========================")
        print(f"Scanned: {len(artifacts)} artifact(s) across {len(roots)} root(s).\n")
        for g in results:
            mark = "READY" if g.ready else ("SKIPPED" if not g.implemented else "BLOCKED")
            print(f"  {g.gate}  {g.name:30s}  [{mark}]")
            if g.stats:
                for k, v in g.stats.items():
                    print(f"        {k}: {v}")
            for b in g.blockers:
                aid = f" [{b['artifact_id']}]" if b.get("artifact_id") else ""
                print(f"        - {b['code']}{aid}: {b['message']}")
            print()

    summary = {
        "scanned_roots": [str(r) for r in roots],
        "artifact_count": len(artifacts),
        "gates": [g.as_dict() for g in results],
    }

    if args.emit_json:
        out = Path(args.emit_json)
        out.parent.mkdir(parents=True, exist_ok=True)
        out.write_text(json.dumps(summary, indent=2) + "\n", encoding="utf-8")
        if not args.quiet:
            print(f"Wrote {out}")

    if args.patch_status:
        _patch_status_json(Path(args.patch_status), results)
        if not args.quiet:
            print(f"Patched {args.patch_status}")

    blocked = [g for g in results if g.implemented and not g.ready]
    if args.ok_if_empty and len(artifacts) == 0:
        return 0
    return 1 if blocked else 0


def _patch_status_json(path: Path, results: list[GateResult]) -> None:
    if not path.exists():
        return
    data = json.loads(path.read_text(encoding="utf-8"))
    gates = data.setdefault("decision_gates", {})
    for g in results:
        # status.json uses naming "G2_requirements_baselined"
        key = f"{g.gate}_{g.name}"
        gates[key] = bool(g.ready) if g.implemented else False
    # store detailed info for the dashboard
    data["decision_gates_detail"] = {
        f"{g.gate}_{g.name}": g.as_dict() for g in results
    }
    path.write_text(json.dumps(data, indent=2) + "\n", encoding="utf-8")


if __name__ == "__main__":
    try:
        sys.exit(main(sys.argv[1:]))
    except KeyboardInterrupt:
        sys.exit(130)
