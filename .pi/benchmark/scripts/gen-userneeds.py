#!/usr/bin/env python3
"""
Deterministically generate N fictive stakeholder-need (STK-*) artifacts for
benchmark scenarios.

Output is reproducible given the same --seed: same count + same seed always
produces byte-identical files. This lets us run the agent multiple times on
*identical* input and measure variance in the agent's output only.

The generated content is intentionally generic — combinatorial templates over
a small corpus of lab-device topics. The point is to have realistic-looking
input, not to model any real product.

Usage:
    gen-userneeds.py --count 50 --seed size-50 --output project/01_Requirements/00_UserNeeds/

Stdlib only. Agent-agnostic.
"""
from __future__ import annotations

import argparse
import datetime as dt
import random
import sys
from pathlib import Path

# -- Corpus ------------------------------------------------------------------
# Combinatorial fragments. Each STK is built by sampling one fragment from
# each list. Keep lists generic and lab-oriented.

ROLES = [
    "Lab Technician",
    "Lab Director",
    "QA Manager",
    "Service Engineer",
    "Regulatory Affairs",
    "IT Administrator",
    "Clinical Stakeholder",
    "Hospital Pharmacist",
    "Biomedical Engineer",
    "Operations Manager",
]

TOPICS = [
    ("sample_loading",      "loading patient samples"),
    ("result_reporting",    "reporting analytical results"),
    ("quality_control",     "running quality-control checks"),
    ("calibration",         "calibrating the instrument"),
    ("user_authentication", "authenticating operators"),
    ("audit_logging",       "recording an audit trail"),
    ("network_interop",     "exchanging data with the LIS"),
    ("error_recovery",      "recovering from transient faults"),
    ("throughput",          "sustaining throughput targets"),
    ("accuracy",            "maintaining analytical accuracy"),
    ("usability",           "completing routine workflows efficiently"),
    ("maintenance",         "performing planned maintenance"),
    ("alarm_handling",      "responding to alarms"),
    ("data_export",         "exporting historical results"),
    ("remote_service",      "supporting remote diagnostics"),
    ("language_support",    "operating in the local language"),
    ("training",            "onboarding new operators"),
    ("inventory_tracking",  "tracking reagent inventory"),
    ("power_continuity",    "surviving brief power interruptions"),
    ("software_update",     "applying software updates"),
    ("waste_management",    "disposing of consumables safely"),
    ("barcode_handling",    "reading barcoded materials"),
    ("temperature_control", "stabilising thermal control loops"),
    ("connectivity",        "supporting wired and wireless connectivity"),
    ("backup",              "backing up instrument configuration"),
]

VERBS = ["complete", "perform", "achieve", "verify", "monitor", "record", "report"]
PRIORITIES = ["must", "must", "must", "should", "should", "could"]   # weighted
TIME_BOUNDS = [None, "within 30 seconds", "within 2 minutes", "within 5 minutes",
               "within 15 minutes", "without operator prompting"]
QUALITY_BOUNDS = [None, "at all times", "without exception", "every workday",
                  "during normal operating hours", "across all reagent lots"]

# -- Templates ---------------------------------------------------------------

BODY_TEMPLATE = """---
id: {id}
type: stakeholder-need
status: approved
priority: {priority}
source: {role}
rationale: {rationale}
created: {date}
updated: {date}
approver: {approver}
---

# {title}

## Need

{role}s must be able to {action}{time_clause}{quality_clause}.

## Context

This need arises during {topic_phrase} as part of routine laboratory operations.
The fictive stakeholder population includes {role}s and adjacent operational
roles. Meeting this need supports the lab's day-to-day commitments.

## Acceptance

The {role}, observed during a representative working shift, demonstrably
{verb}s the required outcome.
"""

# Static synonyms for variety in title generation
TITLE_PREFIXES = [
    "Reliable", "Predictable", "Documented", "Verifiable", "Auditable",
    "Repeatable", "Bounded", "Consistent", "Maintainable", "Recoverable",
]
TITLE_SUFFIXES = [
    "support", "workflow", "outcome", "behaviour", "experience",
    "guarantee", "process", "operation", "service", "result",
]

APPROVER_BY_ROLE = {
    "Lab Technician":      "Lab Director",
    "Lab Director":        "Lab Director",
    "QA Manager":          "QA Manager",
    "Service Engineer":    "Service Manager",
    "Regulatory Affairs":  "Regulatory Affairs",
    "IT Administrator":    "IT Lead",
    "Clinical Stakeholder":"Medical Director",
    "Hospital Pharmacist": "Medical Director",
    "Biomedical Engineer": "Service Manager",
    "Operations Manager":  "Lab Director",
}


def render_one(idx: int, rng: random.Random, date: str) -> tuple[str, str]:
    """Return (filename, file-contents) for the idx-th STK."""
    aid = f"STK-{idx:03d}"
    role = rng.choice(ROLES)
    topic_key, topic_phrase = rng.choice(TOPICS)
    verb = rng.choice(VERBS)
    priority = rng.choice(PRIORITIES)
    time_clause = ""
    qb = rng.choice(QUALITY_BOUNDS)
    tb = rng.choice(TIME_BOUNDS)
    if tb:
        time_clause = f" {tb}"
    quality_clause = ""
    if qb:
        quality_clause = f", {qb}"
    title = f"{rng.choice(TITLE_PREFIXES)} {topic_key.replace('_', ' ')} {rng.choice(TITLE_SUFFIXES)}"
    title = title.capitalize()
    rationale = (
        f"Captures a {priority}-priority need around {topic_phrase} from the "
        f"{role.lower()}'s perspective; unmet, this need would degrade routine operations."
    )
    approver = APPROVER_BY_ROLE.get(role, "Lab Director")
    action = f"{verb} {topic_phrase}"
    body = BODY_TEMPLATE.format(
        id=aid,
        priority=priority,
        role=role,
        rationale=rationale,
        date=date,
        approver=approver,
        title=title,
        action=action,
        time_clause=time_clause,
        quality_clause=quality_clause,
        topic_phrase=topic_phrase,
        verb=verb,
    )
    return f"{aid}.md", body


def main(argv: list[str]) -> int:
    p = argparse.ArgumentParser(description="Generate N fictive STK artifacts.")
    p.add_argument("--count", type=int, required=True, help="Number of STK files to generate.")
    p.add_argument("--seed", required=True, help="Deterministic seed (string).")
    p.add_argument("--output", required=True, help="Output directory.")
    p.add_argument("--date", default=None,
                   help="ISO date used in created/updated fields (default: 2026-01-01 — fixed for reproducibility).")
    p.add_argument("--clean", action="store_true",
                   help="Remove pre-existing STK-*.md files in --output before writing.")
    args = p.parse_args(argv)

    if args.count < 1:
        print("count must be >= 1", file=sys.stderr)
        return 2
    # Cap absurdly large counts to avoid surprises.
    if args.count > 100000:
        print("count too large (>100000)", file=sys.stderr)
        return 2

    date = args.date or "2026-01-01"
    try:
        dt.date.fromisoformat(date)
    except ValueError:
        print(f"--date must be ISO 8601 YYYY-MM-DD; got {date!r}", file=sys.stderr)
        return 2

    out = Path(args.output).resolve()
    out.mkdir(parents=True, exist_ok=True)

    if args.clean:
        for old in out.glob("STK-*.md"):
            old.unlink()

    rng = random.Random(args.seed)
    written = 0
    for i in range(1, args.count + 1):
        name, body = render_one(i, rng, date)
        (out / name).write_text(body, encoding="utf-8")
        written += 1

    print(f"Wrote {written} STK artifact(s) to {out} (seed={args.seed!r}, date={date}).")
    return 0


if __name__ == "__main__":
    try:
        sys.exit(main(sys.argv[1:]))
    except KeyboardInterrupt:
        sys.exit(130)
