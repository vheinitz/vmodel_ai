#!/usr/bin/env python3
"""
Aggregate multiple benchmark snapshots into mean / stddev / CV statistics and
Jaccard similarity between pairs of runs. Helps answer "is the agent
deterministic on identical input?".

Inputs:
    * --scenario NAME — looks under $BENCHMARK_RESULTS_DIR/<repo-slug>/<scenario>/run-*-after.json
    * --files PATH... — explicit list of snapshot files

Outputs human-readable summary to stdout; optional --emit-json for the
machine-readable report.

Stdlib only. Agent-agnostic.
"""
from __future__ import annotations

import argparse
import json
import math
import os
import statistics
import sys
from pathlib import Path

DEFAULT_RESULTS_ROOT = Path.home() / ".cache" / "vmodel-benchmark"


def repo_slug() -> str:
    cwd = Path.cwd().resolve()
    return cwd.name


def default_results_dir() -> Path:
    base = Path(os.environ.get("BENCHMARK_RESULTS_DIR", DEFAULT_RESULTS_ROOT))
    return base / repo_slug()


def load_snapshots(paths: list[Path]) -> list[dict]:
    out = []
    for p in paths:
        try:
            out.append(json.loads(p.read_text(encoding="utf-8")))
        except Exception as e:
            print(f"compare-runs: skip {p}: {e}", file=sys.stderr)
    return out


def find_after_snapshots(scenario: str) -> list[Path]:
    root = default_results_dir() / scenario
    if not root.exists():
        return []
    return sorted(root.glob("run-*-after.json"))


def numeric_metric(snap: dict, path: list[str]):
    cur = snap
    for k in path:
        if not isinstance(cur, dict) or k not in cur:
            return None
        cur = cur[k]
    return cur if isinstance(cur, (int, float)) else None


def summarize_numeric(snaps: list[dict], path: list[str]) -> dict:
    vals = [numeric_metric(s, path) for s in snaps]
    vals = [v for v in vals if v is not None]
    if not vals:
        return {"n": 0}
    mean = statistics.fmean(vals)
    sd = statistics.pstdev(vals) if len(vals) > 1 else 0.0
    cv = (sd / mean) if mean else None
    return {
        "n": len(vals),
        "mean": round(mean, 4),
        "stdev": round(sd, 4),
        "cv": round(cv, 4) if cv is not None else None,
        "min": min(vals),
        "max": max(vals),
    }


def jaccard(a: set, b: set) -> float:
    if not a and not b:
        return 1.0
    u = a | b
    if not u:
        return 1.0
    return len(a & b) / len(u)


def pairwise_jaccard(id_sets: list[set]) -> dict:
    n = len(id_sets)
    if n < 2:
        return {"pairs": 0, "mean": None, "min": None, "max": None}
    scores = []
    for i in range(n):
        for j in range(i + 1, n):
            scores.append(jaccard(id_sets[i], id_sets[j]))
    return {
        "pairs": len(scores),
        "mean": round(statistics.fmean(scores), 4),
        "min": round(min(scores), 4),
        "max": round(max(scores), 4),
    }


def aggregate(snaps: list[dict]) -> dict:
    n = len(snaps)
    if n == 0:
        return {"n": 0}

    # Numeric summaries
    metrics: dict[str, dict] = {}

    metrics["artifact_count_total"] = summarize_numeric(snaps, ["artifact_count_total"])

    all_types = sorted({t for s in snaps for t in s.get("artifact_counts", {})})
    for t in all_types:
        metrics[f"artifact_counts.{t}"] = summarize_numeric(snaps, ["artifact_counts", t])

    metrics["validation.errors"] = summarize_numeric(snaps, ["validation", "errors"])
    metrics["validation.warnings"] = summarize_numeric(snaps, ["validation", "warnings"])

    coverage_keys = sorted({k for s in snaps for k in s.get("trace_coverage", {})})
    for k in coverage_keys:
        metrics[f"trace_coverage.{k}.ratio"] = summarize_numeric(
            snaps, ["trace_coverage", k, "ratio"])

    # Gate pass rates
    gate_pass_rate: dict[str, dict] = {}
    for gkey in sorted({g for s in snaps for g in s.get("gates", {})}):
        readies = [s.get("gates", {}).get(gkey, {}).get("ready") for s in snaps]
        readies = [bool(x) for x in readies if x is not None]
        if readies:
            gate_pass_rate[gkey] = {
                "ready_runs": sum(readies),
                "total_runs": len(readies),
                "pass_rate": round(sum(readies) / len(readies), 4),
            }

    # Jaccard similarity per artifact type
    similarity: dict[str, dict] = {}
    for t in all_types:
        id_sets = [set(s.get("artifact_ids", {}).get(t, [])) for s in snaps]
        similarity[t] = pairwise_jaccard(id_sets)

    return {
        "n_runs": n,
        "metrics": metrics,
        "gate_pass_rate": gate_pass_rate,
        "id_set_similarity": similarity,
    }


def print_report(report: dict, snap_paths: list[Path]) -> None:
    print("Benchmark — Run Comparison")
    print("==========================")
    print(f"Runs aggregated: {report.get('n_runs', 0)}")
    for p in snap_paths:
        print(f"  - {p}")
    if not report.get("n_runs"):
        print("No snapshots to aggregate.")
        return
    print()
    print("Numeric metrics  (mean ± stdev,  CV)")
    print("-" * 60)
    for name, s in report["metrics"].items():
        if s.get("n", 0) == 0:
            continue
        mean = s["mean"]
        stdev = s["stdev"]
        cv = s["cv"]
        cv_str = f"{cv:.3f}" if isinstance(cv, (int, float)) else "—"
        print(f"  {name:48s} {mean:10.3f} ± {stdev:7.3f}   CV={cv_str}")
    print()
    print("Gate pass rate")
    print("-" * 60)
    for g, r in report["gate_pass_rate"].items():
        print(f"  {g}: {r['ready_runs']}/{r['total_runs']}  ({r['pass_rate']*100:.1f}%)")
    print()
    print("ID-set similarity (Jaccard, pairwise across runs)")
    print("-" * 60)
    for t, s in report["id_set_similarity"].items():
        if s["pairs"] == 0:
            continue
        print(f"  {t:30s} pairs={s['pairs']:3d}  mean={s['mean']:.3f}  "
              f"min={s['min']:.3f}  max={s['max']:.3f}")


def main(argv: list[str]) -> int:
    p = argparse.ArgumentParser(description="Aggregate benchmark snapshots.")
    g = p.add_mutually_exclusive_group(required=True)
    g.add_argument("--scenario", help="Scenario name; reads run-*-after.json from the standard results dir.")
    g.add_argument("--files", nargs="+", help="Explicit list of snapshot JSON files.")
    p.add_argument("--emit-json", help="Write aggregated report JSON to this path.")
    p.add_argument("--quiet", action="store_true")
    args = p.parse_args(argv)

    if args.scenario:
        paths = find_after_snapshots(args.scenario)
        if not paths:
            print(f"No snapshots found under {default_results_dir() / args.scenario}",
                  file=sys.stderr)
            return 2
    else:
        paths = [Path(f) for f in args.files]

    snaps = load_snapshots(paths)
    report = aggregate(snaps)

    if not args.quiet:
        print_report(report, paths)

    if args.emit_json:
        out = Path(args.emit_json)
        out.parent.mkdir(parents=True, exist_ok=True)
        out.write_text(json.dumps(report, indent=2) + "\n", encoding="utf-8")
        if not args.quiet:
            print(f"\nWrote {out}")

    return 0


if __name__ == "__main__":
    try:
        sys.exit(main(sys.argv[1:]))
    except KeyboardInterrupt:
        sys.exit(130)
