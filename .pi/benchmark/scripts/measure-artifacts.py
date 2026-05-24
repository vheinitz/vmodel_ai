#!/usr/bin/env python3
"""
Snapshot project state for benchmark measurement.

Walks a project/ tree, counts artifacts by type, runs the validator, runs the
gate engine, and computes trace-coverage metrics. Emits a single JSON document
suitable for diff/compare-runs.py.

Usage:
    measure-artifacts.py --project-root project/ \
        [--emit-json path/to/snapshot.json] \
        [--label "before|after"]

Stdlib only. Agent-agnostic.
"""
from __future__ import annotations

import argparse
import datetime as dt
import importlib.util
import json
import sys
from collections import defaultdict
from pathlib import Path

# ---------------------------------------------------------------------------
# Re-use validator + gate-engine logic by importing them from .pi/scripts/.
# ---------------------------------------------------------------------------

THIS = Path(__file__).resolve()
REPO = THIS.parent.parent.parent.parent   # .../benchmark (repo root)
PI_SCRIPTS = REPO / ".pi" / "scripts"


def _import_local(modname: str, filename: str):
    spec = importlib.util.spec_from_file_location(modname, PI_SCRIPTS / filename)
    mod = importlib.util.module_from_spec(spec)
    assert spec.loader is not None
    sys.modules[modname] = mod
    spec.loader.exec_module(mod)
    return mod


_va = _import_local("validate_artifacts", "validate-artifacts.py")
_cg = _import_local("check_gates_mod", "check-gates.py")


# ---------------------------------------------------------------------------
# Measurement
# ---------------------------------------------------------------------------

def measure(project_root: Path) -> dict:
    report = _va.Report()
    index = _va.collect_artifacts([project_root], report)
    # Run validator over the collected artifacts.
    for a in report.artifacts:
        _va.validate_artifact(a, index, report)

    artifacts_by_type: dict[str, list] = defaultdict(list)
    for a in report.artifacts:
        artifacts_by_type[a.type].append(a)

    artifact_counts = {t: len(arts) for t, arts in artifacts_by_type.items()}
    artifact_ids = {
        t: sorted(a.id for a in arts) for t, arts in artifacts_by_type.items()
    }

    # Validation summary
    findings_by_code: dict[str, int] = defaultdict(int)
    for f in report.findings:
        findings_by_code[f.code] += 1
    validation = {
        "errors": report.errors,
        "warnings": report.warnings,
        "by_code": dict(findings_by_code),
    }

    # Gate readiness — all gates (G2 evaluated, others stubbed).
    gate_results = []
    for gkey in _cg.GATE_NAMES:
        evaluator = _cg.GATE_EVALUATORS.get(gkey)
        gate_results.append(evaluator(report.artifacts) if evaluator else _cg.evaluate_stub(gkey))
    gates = {g.gate: g.as_dict() for g in gate_results}

    coverage = _coverage(artifacts_by_type)

    return {
        "scanned_at": dt.datetime.now().isoformat(timespec="seconds"),
        "project_root": str(project_root),
        "artifact_counts": artifact_counts,
        "artifact_count_total": sum(artifact_counts.values()),
        "artifact_ids": artifact_ids,
        "validation": validation,
        "gates": gates,
        "trace_coverage": coverage,
    }


def _coverage(by_type: dict[str, list]) -> dict:
    """Compute trace-coverage ratios across the V-Model chain."""
    stk = by_type.get("stakeholder-need", [])
    sysreq = by_type.get("system-requirement", [])
    swreq = by_type.get("software-requirement", [])
    fmea = by_type.get("fmea-entry", [])

    # Inverse indexes: which IDs are *referenced* downstream?
    sysreq_sources: set[str] = set()
    for a in sysreq:
        for s in _as_list(a.frontmatter.get("source")):
            sysreq_sources.add(s)
    swreq_sources: set[str] = set()
    for a in swreq:
        for s in _as_list(a.frontmatter.get("source")):
            swreq_sources.add(s)

    safety_sysreq = [a for a in sysreq if a.frontmatter.get("category") == "safety"]
    safety_swreq = [a for a in swreq if a.frontmatter.get("category") == "safety"]

    return {
        "stk_with_downstream_sysreq": _ratio(
            sum(1 for a in stk if a.id in sysreq_sources), len(stk)
        ),
        "sysreq_with_downstream_swreq": _ratio(
            sum(1 for a in sysreq if a.id in swreq_sources), len(sysreq)
        ),
        "sysreq_with_test": _ratio(
            sum(1 for a in sysreq if _as_list(a.frontmatter.get("tests"))), len(sysreq)
        ),
        "swreq_with_test": _ratio(
            sum(1 for a in swreq if _as_list(a.frontmatter.get("tests"))), len(swreq)
        ),
        "safety_sysreq_with_fmea": _ratio(
            sum(1 for a in safety_sysreq if _as_list(a.frontmatter.get("risks"))),
            len(safety_sysreq),
        ),
        "safety_swreq_with_fmea": _ratio(
            sum(1 for a in safety_swreq if _as_list(a.frontmatter.get("risks"))),
            len(safety_swreq),
        ),
        "fmea_with_control": _ratio(
            sum(1 for a in fmea if _as_list(a.frontmatter.get("controls"))),
            len(fmea),
        ),
    }


def _ratio(num: int, denom: int) -> dict:
    return {"count": num, "total": denom,
            "ratio": (num / denom) if denom else None}


def _as_list(v) -> list:
    if v is None or v == "":
        return []
    if isinstance(v, list):
        return [x for x in v if x not in (None, "")]
    return [v]


# ---------------------------------------------------------------------------
# CLI
# ---------------------------------------------------------------------------

def main(argv: list[str]) -> int:
    p = argparse.ArgumentParser(description="Snapshot project state for benchmark measurement.")
    p.add_argument("--project-root", required=True, help="Project root directory (e.g. project).")
    p.add_argument("--emit-json", help="Write snapshot JSON to this path.")
    p.add_argument("--label", help="Optional label (e.g. 'before', 'after') stored in the snapshot.")
    p.add_argument("--quiet", action="store_true")
    args = p.parse_args(argv)

    root = Path(args.project_root).resolve()
    if not root.exists():
        print(f"project root does not exist: {root}", file=sys.stderr)
        return 2

    snap = measure(root)
    if args.label:
        snap["label"] = args.label

    if not args.quiet:
        print(json.dumps(snap, indent=2))

    if args.emit_json:
        out = Path(args.emit_json)
        out.parent.mkdir(parents=True, exist_ok=True)
        out.write_text(json.dumps(snap, indent=2) + "\n", encoding="utf-8")
        if not args.quiet:
            print(f"\nWrote {out}", file=sys.stderr)

    return 0


if __name__ == "__main__":
    try:
        sys.exit(main(sys.argv[1:]))
    except KeyboardInterrupt:
        sys.exit(130)
