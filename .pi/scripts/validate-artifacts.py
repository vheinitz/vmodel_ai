#!/usr/bin/env python3
"""
V-Model XT artifact validator.

Walks one or more roots, parses YAML frontmatter from every .md file, and
validates each artifact against the schema in .pi/rules/artifact-frontmatter.md.

Output:
    Human-readable findings to stdout (always).
    Machine-readable JSON to dashboard/data/validation.json (when --emit-json).

Exit codes:
    0  no errors (warnings allowed)
    1  at least one error
    2  invocation problem (paths, IO, etc.)

Stdlib only. Works with any Python >= 3.8. Agent-agnostic.
"""
from __future__ import annotations

import argparse
import json
import re
import sys
from dataclasses import dataclass, field
from datetime import date, datetime
from pathlib import Path

# ---------------------------------------------------------------------------
# Schema (mirrors .pi/rules/artifact-frontmatter.md — keep in sync)
# ---------------------------------------------------------------------------

# Required keys per artifact type. Keys marked optional via OPTIONAL_KEYS below.
REQUIRED_KEYS: dict[str, set[str]] = {
    "stakeholder-need": {
        "id", "type", "status", "priority", "source", "rationale",
        "created", "updated", "approver",
    },
    "system-requirement": {
        "id", "type", "status", "priority", "category", "source", "rationale",
        "verification_method", "risks", "tests", "created", "updated", "approver",
    },
    "software-requirement": {
        "id", "type", "component", "status", "priority", "category",
        "source", "rationale", "verification_method", "risks", "tests",
        "created", "updated", "approver",
    },
    "fmea-entry": {
        "id", "type", "status", "hazard", "hazardous_situation", "harm",
        "severity", "probability", "detection", "rpn", "controls",
        "residual_severity", "residual_probability", "residual_acceptable",
        "related_requirements", "tests", "created", "updated", "approver",
    },
    "test-case": {
        "id", "type", "level", "status", "verifies",
        "preconditions", "steps", "expected_result",
        "last_result", "created", "updated",
    },
    "architecture-component": {
        "id", "type", "layer", "status", "realizes", "interfaces",
        "created", "updated",
    },
    "design-module": {
        "id", "type", "component", "status", "implements", "source_path",
        "created", "updated",
    },
    "adr": {
        "id", "type", "status", "decision", "context", "consequences",
        "created", "updated",
    },
}

# Closed vocabularies. Maps (type, field) -> allowed values; field-only entries
# apply to every type.
VOCAB: dict[tuple[str | None, str], set[str]] = {
    (None, "priority"): {"must", "should", "could"},
    (None, "category"): {"functional", "non-functional", "safety", "regulatory", "interface"},
    (None, "verification_method"): {"test", "inspection", "analysis", "demonstration"},
    (None, "safety_class"): {"A", "B", "C"},
    (None, "layer"): {"system", "software", "hardware"},
    (None, "last_result"): {"pass", "fail", "not-run"},
    ("stakeholder-need", "status"): {"draft", "reviewed", "approved", "superseded"},
    ("system-requirement", "status"): {"draft", "reviewed", "baselined", "superseded"},
    ("software-requirement", "status"): {"draft", "reviewed", "baselined", "superseded"},
    ("architecture-component", "status"): {"draft", "reviewed", "baselined", "superseded"},
    ("design-module", "status"): {"draft", "reviewed", "baselined", "superseded"},
    ("fmea-entry", "status"): {"draft", "reviewed", "controlled", "accepted", "superseded"},
    ("test-case", "status"): {"draft", "reviewed", "passing", "failing", "blocked"},
    ("test-case", "level"): {"unit", "integration", "system", "architecture"},
    ("adr", "status"): {"proposed", "accepted", "superseded", "deprecated"},
}

# Per-type ID regex.
ID_PATTERNS: dict[str, re.Pattern[str]] = {
    "stakeholder-need":       re.compile(r"^STK-\d{3,}$"),
    "system-requirement":     re.compile(r"^REQ-SYS-\d{3,}$"),
    "software-requirement":   re.compile(r"^REQ-SW-[A-Z]{2,4}-\d{3,}$"),
    "fmea-entry":             re.compile(r"^FMEA-\d{3,}$"),
    "test-case":              re.compile(r"^TC-(UNIT|INT|SYS|ARCH)-\d{3,}$"),
    "architecture-component": re.compile(r"^COMP-\d{3,}$"),
    "design-module":          re.compile(r"^MOD-\d{3,}$"),
    "adr":                    re.compile(r"^ADR-\d{3,}$"),
}

# Fields whose values are references to other artifact IDs.
# Some fields are links for one type but free strings for another — see _is_link below.
LINK_FIELDS: set[str] = {
    "source", "risks", "tests", "verifies", "mitigates", "realizes",
    "implements", "controls", "related_requirements", "supersedes", "component",
}

# Paths to skip during scanning (template stubs, archives, etc.).
SKIP_PATH_SEGMENTS = {
    "10_Documentation/templates",
    "99_Archive",
    "_Archiv",
    "_Trash",
    ".git",
    "node_modules",
}


def _is_link(field_name: str, artifact_type: str) -> bool:
    """Return True if `field_name` should be resolved as an artifact ID for this type."""
    if field_name not in LINK_FIELDS:
        return False
    # `source` on stakeholder-need is a free-text string (e.g. "Lab Director"), not a link.
    if field_name == "source" and artifact_type == "stakeholder-need":
        return False
    # `component` on software-requirement is a component code (e.g. "AC"), not an ID.
    if field_name == "component" and artifact_type == "software-requirement":
        return False
    return True

# Statuses that mean "baselined or beyond" — trigger orphan checks.
BASELINED_STATUSES = {"baselined", "approved", "controlled", "accepted"}

# ---------------------------------------------------------------------------
# Minimal frontmatter parser (no external deps)
# ---------------------------------------------------------------------------

FRONTMATTER_RE = re.compile(r"\A---\s*\n(.*?)\n---\s*\n", re.DOTALL)


def parse_frontmatter(text: str) -> dict | None:
    """Return parsed frontmatter dict, or None if no frontmatter block."""
    m = FRONTMATTER_RE.match(text)
    if not m:
        return None
    block = m.group(1)
    return _parse_yaml_subset(block)


def _parse_yaml_subset(block: str) -> dict:
    """
    Parse a YAML subset sufficient for our schema:
      - 'key: value' scalar lines
      - 'key: [a, b, c]' inline arrays
      - 'key:' with following '  - item' lines (block arrays)
      - '# comment' lines and blank lines ignored
      - quoted strings 'foo' or "foo" stripped of quotes
      - bare booleans (true/false), nulls (null/~), integers, floats
    """
    out: dict = {}
    lines = block.splitlines()
    i = 0
    while i < len(lines):
        raw = lines[i]
        stripped = raw.strip()
        if not stripped or stripped.startswith("#"):
            i += 1
            continue
        if ":" not in stripped:
            i += 1
            continue
        key, _, rest = stripped.partition(":")
        key = key.strip()
        value_text = rest.strip()
        # strip trailing inline comment
        if value_text and "#" in value_text:
            # don't strip '#' inside quoted strings — naive but adequate
            if not (value_text.startswith(("'", '"'))):
                value_text = value_text.split("#", 1)[0].strip()
        # Block array
        if value_text == "" and i + 1 < len(lines) and lines[i + 1].lstrip().startswith("- "):
            items = []
            i += 1
            while i < len(lines) and lines[i].lstrip().startswith("- "):
                items.append(_coerce_scalar(lines[i].lstrip()[2:].strip()))
                i += 1
            out[key] = items
            continue
        # Inline array
        if value_text.startswith("[") and value_text.endswith("]"):
            inner = value_text[1:-1].strip()
            if inner == "":
                out[key] = []
            else:
                out[key] = [_coerce_scalar(p.strip()) for p in inner.split(",")]
            i += 1
            continue
        # Scalar
        out[key] = _coerce_scalar(value_text)
        i += 1
    return out


def _coerce_scalar(text: str):
    if text == "":
        return ""
    if (text.startswith("'") and text.endswith("'")) or (
        text.startswith('"') and text.endswith('"')
    ):
        return text[1:-1]
    low = text.lower()
    if low in ("null", "~"):
        return None
    if low == "true":
        return True
    if low == "false":
        return False
    # integer
    try:
        return int(text)
    except ValueError:
        pass
    # float
    try:
        return float(text)
    except ValueError:
        pass
    return text


# ---------------------------------------------------------------------------
# Validation
# ---------------------------------------------------------------------------

@dataclass
class Finding:
    severity: str            # "error" | "warning" | "info"
    file: str
    artifact_id: str | None
    code: str
    message: str

    def as_dict(self) -> dict:
        return {
            "severity": self.severity,
            "file": self.file,
            "artifact_id": self.artifact_id,
            "code": self.code,
            "message": self.message,
        }


@dataclass
class Artifact:
    path: Path
    frontmatter: dict
    type: str
    id: str

    @property
    def status(self) -> str:
        return str(self.frontmatter.get("status", ""))


@dataclass
class Report:
    findings: list[Finding] = field(default_factory=list)
    artifacts: list[Artifact] = field(default_factory=list)

    def add(self, severity: str, file: Path | str, artifact_id: str | None,
            code: str, message: str) -> None:
        self.findings.append(Finding(severity, str(file), artifact_id, code, message))

    @property
    def errors(self) -> int:
        return sum(1 for f in self.findings if f.severity == "error")

    @property
    def warnings(self) -> int:
        return sum(1 for f in self.findings if f.severity == "warning")


def collect_artifacts(roots: list[Path], report: Report) -> dict[str, Artifact]:
    """Walk roots, parse frontmatter, index by id. Files without frontmatter are skipped silently."""
    by_id: dict[str, Artifact] = {}
    for root in roots:
        if not root.exists():
            continue
        for md in sorted(root.rglob("*.md")):
            if _should_skip(md):
                continue
            text = md.read_text(encoding="utf-8", errors="replace")
            fm = parse_frontmatter(text)
            if fm is None:
                continue  # not an artifact, just a doc
            atype = fm.get("type")
            aid = fm.get("id")
            if not atype or not aid:
                report.add("error", md, aid, "missing-type-or-id",
                           "Frontmatter is missing 'type' and/or 'id'.")
                continue
            if atype not in REQUIRED_KEYS:
                # Unknown type — accept silently (document-cover etc.), but record for stats.
                continue
            if aid in by_id:
                report.add("error", md, aid, "duplicate-id",
                           f"Duplicate artifact id {aid!r}; also at {by_id[aid].path}.")
                continue
            artifact = Artifact(path=md, frontmatter=fm, type=atype, id=aid)
            by_id[aid] = artifact
            report.artifacts.append(artifact)
    return by_id


def validate_artifact(a: Artifact, index: dict[str, Artifact], report: Report) -> None:
    fm = a.frontmatter
    required = REQUIRED_KEYS[a.type]

    # 1. Required keys present and non-empty
    for key in required:
        if key not in fm:
            report.add("error", a.path, a.id, "missing-key",
                       f"Missing required key {key!r}.")
            continue
        v = fm[key]
        if v is None or v == "" or v == []:
            # arrays may legitimately be empty (e.g. tests: [] before tests exist) — soften:
            if key in {"tests", "risks", "mitigates"}:
                continue
            report.add("error", a.path, a.id, "empty-key",
                       f"Required key {key!r} is empty.")

    # 2. Filename match
    expected_name = f"{a.id}.md"
    if a.path.name != expected_name:
        report.add("error", a.path, a.id, "filename-mismatch",
                   f"Filename {a.path.name!r} does not match id; expected {expected_name!r}.")

    # 3. ID format
    pattern = ID_PATTERNS.get(a.type)
    if pattern and not pattern.match(a.id):
        report.add("error", a.path, a.id, "id-format",
                   f"Id {a.id!r} does not match pattern {pattern.pattern} for type {a.type}.")

    # 4. Closed vocabularies
    for (vtype, vfield), allowed in VOCAB.items():
        if vtype is not None and vtype != a.type:
            continue
        if vfield not in fm:
            continue
        val = fm[vfield]
        if val is None or val == "":
            continue
        if val not in allowed:
            report.add("error", a.path, a.id, "bad-vocabulary",
                       f"{vfield}={val!r} not in {sorted(allowed)}.")

    # 5. Date format
    for dkey in ("created", "updated", "last_run"):
        if dkey in fm and fm[dkey] not in (None, ""):
            v = fm[dkey]
            if not _is_iso_date(v):
                report.add("error", a.path, a.id, "bad-date",
                           f"{dkey}={v!r} is not ISO 8601 YYYY-MM-DD.")

    # 6. Link integrity
    for lf in LINK_FIELDS:
        if lf not in fm or fm[lf] in (None, ""):
            continue
        if not _is_link(lf, a.type):
            continue
        targets = fm[lf] if isinstance(fm[lf], list) else [fm[lf]]
        for t in targets:
            if not isinstance(t, str):
                continue
            if t not in index:
                report.add("error", a.path, a.id, "broken-link",
                           f"{lf} references {t!r}, which is not a known artifact.")
                continue
            # Stale link detection
            try:
                self_upd = _to_date(fm.get("updated"))
                target_upd = _to_date(index[t].frontmatter.get("updated"))
                if self_upd and target_upd and target_upd > self_upd:
                    report.add("warning", a.path, a.id, "stale-link",
                               f"{lf} -> {t}: target updated {target_upd} after this artifact ({self_upd}).")
            except Exception:
                pass

    # 7. Orphan checks for baselined-or-beyond
    if a.status in BASELINED_STATUSES:
        if a.type in {"system-requirement", "software-requirement"}:
            if not fm.get("tests"):
                report.add("error", a.path, a.id, "orphan-no-test",
                           "Baselined requirement has no test linked.")
            if fm.get("category") == "safety" and not fm.get("risks"):
                report.add("error", a.path, a.id, "orphan-safety-no-risk",
                           "Baselined safety requirement has no FMEA linked.")

    # 8. FMEA: RPN consistency
    if a.type == "fmea-entry":
        sev, prob, det = fm.get("severity"), fm.get("probability"), fm.get("detection")
        rpn = fm.get("rpn")
        if all(isinstance(x, int) for x in (sev, prob, det, rpn)):
            if sev * prob * det != rpn:
                report.add("error", a.path, a.id, "rpn-mismatch",
                           f"RPN={rpn} does not equal severity*probability*detection ({sev*prob*det}).")

    # 9. Software-requirement: safety_class required iff category=safety
    if a.type == "software-requirement":
        if fm.get("category") == "safety" and not fm.get("safety_class"):
            report.add("error", a.path, a.id, "missing-safety-class",
                       "category=safety but safety_class is missing.")


def _is_iso_date(v) -> bool:
    if not isinstance(v, str):
        return False
    try:
        datetime.strptime(v, "%Y-%m-%d")
        return True
    except ValueError:
        return False


def _to_date(v) -> date | None:
    if not isinstance(v, str):
        return None
    try:
        return datetime.strptime(v, "%Y-%m-%d").date()
    except ValueError:
        return None


def _should_skip(path: Path) -> bool:
    parts = path.as_posix()
    return any(seg in parts for seg in SKIP_PATH_SEGMENTS)


# ---------------------------------------------------------------------------
# CLI
# ---------------------------------------------------------------------------

def main(argv: list[str]) -> int:
    p = argparse.ArgumentParser(description="Validate V-Model XT artifact frontmatter.")
    p.add_argument("roots", nargs="*", default=["project"],
                   help="One or more directories to scan (default: project).")
    p.add_argument("--emit-json", metavar="PATH",
                   help="Write findings JSON to PATH (e.g. dashboard/data/validation.json).")
    p.add_argument("--quiet", action="store_true", help="Suppress per-finding stdout.")
    args = p.parse_args(argv)

    roots = [Path(r).resolve() for r in args.roots]
    for r in roots:
        if not r.exists():
            print(f"validate-artifacts: warning: path {r} does not exist", file=sys.stderr)

    report = Report()
    index = collect_artifacts(roots, report)

    for artifact in report.artifacts:
        validate_artifact(artifact, index, report)

    if not args.quiet:
        for f in report.findings:
            sev = f.severity.upper()
            loc = f.file
            print(f"{sev:7s} {f.code:24s} {loc} :: {f.message}")

    summary = {
        "scanned_roots": [str(r) for r in roots],
        "artifact_count": len(report.artifacts),
        "errors": report.errors,
        "warnings": report.warnings,
        "by_type": _count_by_type(report.artifacts),
        "findings": [f.as_dict() for f in report.findings],
        "generated_at": datetime.now().isoformat(timespec="seconds"),
    }

    if args.emit_json:
        out = Path(args.emit_json)
        out.parent.mkdir(parents=True, exist_ok=True)
        out.write_text(json.dumps(summary, indent=2) + "\n", encoding="utf-8")
        if not args.quiet:
            print(f"\nWrote {out}")

    print(f"\n{len(report.artifacts)} artifact(s) scanned.  "
          f"{report.errors} error(s), {report.warnings} warning(s).")

    return 0 if report.errors == 0 else 1


def _count_by_type(arts: list[Artifact]) -> dict[str, int]:
    counts: dict[str, int] = {}
    for a in arts:
        counts[a.type] = counts.get(a.type, 0) + 1
    return counts


if __name__ == "__main__":
    try:
        sys.exit(main(sys.argv[1:]))
    except KeyboardInterrupt:
        sys.exit(130)
