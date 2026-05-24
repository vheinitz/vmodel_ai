#!/usr/bin/env bash
# Benchmark orchestrator — one run of the V-Model pipeline benchmark.
#
# - Refuses to run on a dirty working tree (prevents accidental loss of work).
# - Refuses to run anywhere except `master` (forces template-purity).
# - Creates a disposable test branch and operates entirely on it.
# - Generates fictive STK artifacts, snapshots baseline, invokes pi, snapshots
#   final, writes both to $BENCHMARK_RESULTS_DIR (outside the repo), and
#   returns to master.
#
# Required env / CLI:
#   SCENARIO=<scenario-name>      e.g. size-50  (must match .pi/benchmark/scenarios/<name>.json)
# Optional:
#   RUN_ID=<integer>              defaults to a timestamp
#   PI_CMD="pi"                   override the agent CLI
#   BENCHMARK_RESULTS_DIR=...     override where snapshots are written
#                                 (default: ~/.cache/vmodel-benchmark/<repo>)
#   PROMPT_FILE=...               override the prompt sent to pi
#                                 (default: .pi/benchmark/prompts/v-model-pipeline.md)
#   TIMEOUT_SECONDS=1800          kill pi after this many seconds (default 30 min)
#   DRY_RUN=1                     do everything except invoke pi
#   KEEP_BRANCH=1                 do not switch back to master at the end
#
# Exit codes:
#   0   completed successfully (pi returned 0)
#   1   pi returned non-zero (final snapshot is still captured)
#   2   pre-flight failure (dirty tree, wrong branch, missing scenario, ...)
#   124 pi timed out

set -uo pipefail

# -- Pre-flight --------------------------------------------------------------

err() { echo "run-benchmark: $*" >&2; }
die() { err "$*"; exit "${2:-2}"; }

SCENARIO="${SCENARIO:-${1:-}}"
[ -n "$SCENARIO" ] || die "SCENARIO not set (usage: SCENARIO=size-50 $0  or  $0 size-50)"

# Find repo root via git so the script works from any cwd inside the repo.
REPO_ROOT="$(git rev-parse --show-toplevel 2>/dev/null)" \
    || die "not inside a git repository"
cd "$REPO_ROOT"

SCENARIO_FILE=".pi/benchmark/scenarios/${SCENARIO}.json"
[ -f "$SCENARIO_FILE" ] || die "scenario file not found: $SCENARIO_FILE"

GEN_SCRIPT=".pi/benchmark/scripts/gen-userneeds.py"
MEASURE_SCRIPT=".pi/benchmark/scripts/measure-artifacts.py"
PROMPT_FILE="${PROMPT_FILE:-.pi/benchmark/prompts/v-model-pipeline.md}"
[ -f "$PROMPT_FILE" ] || die "prompt file not found: $PROMPT_FILE"

CURRENT_BRANCH="$(git rev-parse --abbrev-ref HEAD)"
[ "$CURRENT_BRANCH" = "master" ] \
    || die "must be on 'master' (currently on '$CURRENT_BRANCH'). Refuse to mix benchmark data with feature work."

if ! git diff --quiet HEAD || [ -n "$(git ls-files --others --exclude-standard)" ]; then
    die "working tree is dirty. Commit or stash first; benchmark refuses to risk mixing fictive product data with real changes."
fi

PI_CMD="${PI_CMD:-pi}"
TIMEOUT_SECONDS="${TIMEOUT_SECONDS:-1800}"
DRY_RUN="${DRY_RUN:-0}"
KEEP_BRANCH="${KEEP_BRANCH:-0}"

REPO_SLUG="$(basename "$REPO_ROOT")"
BENCHMARK_RESULTS_DIR="${BENCHMARK_RESULTS_DIR:-$HOME/.cache/vmodel-benchmark/$REPO_SLUG}"
RESULTS_DIR="$BENCHMARK_RESULTS_DIR/$SCENARIO"
mkdir -p "$RESULTS_DIR"

RUN_ID="${RUN_ID:-$(date +%Y%m%d-%H%M%S)}"
RUN_LABEL="run-${RUN_ID}"

# Read scenario fields with python (avoids depending on jq).
read -r COUNT SEED < <(python3 - "$SCENARIO_FILE" <<'PY'
import json, sys
d = json.load(open(sys.argv[1]))
print(d["count"], d.get("seed", d["name"]))
PY
)
[ -n "$COUNT" ] || die "failed to parse scenario $SCENARIO_FILE"

BRANCH="benchmark/${SCENARIO}-${RUN_LABEL}"

# -- Plan summary ------------------------------------------------------------

cat <<EOF
Benchmark run
=============
Repo:            $REPO_ROOT
Scenario:        $SCENARIO   (count=$COUNT, seed=$SEED)
Run id:          $RUN_ID
Branch:          $BRANCH
Prompt:          $PROMPT_FILE
Agent command:   $PI_CMD
Timeout:         ${TIMEOUT_SECONDS}s
Results dir:     $RESULTS_DIR
Dry run:         $([ "$DRY_RUN" = "1" ] && echo yes || echo no)
EOF
echo

# -- Create branch -----------------------------------------------------------

git checkout -b "$BRANCH" >/dev/null \
    || die "could not create branch $BRANCH"

# Cleanup function: return to master unless KEEP_BRANCH=1.
cleanup() {
    local rc=$?
    if [ "$KEEP_BRANCH" != "1" ]; then
        git checkout --quiet master 2>/dev/null \
            || err "could not return to master; you are still on $BRANCH"
        echo "Returned to master. Test branch left at: $BRANCH"
    else
        echo "KEEP_BRANCH=1 — staying on $BRANCH"
    fi
    return $rc
}
trap cleanup EXIT

# -- Generate input ----------------------------------------------------------

OUT_DIR="project/01_Requirements/00_UserNeeds"
echo "[1/5] Generating $COUNT STK artifacts into $OUT_DIR ..."
python3 "$GEN_SCRIPT" --count "$COUNT" --seed "$SEED" --output "$OUT_DIR" --clean \
    || die "gen-userneeds failed"

git add "$OUT_DIR"
git commit --quiet -m "benchmark: generate $COUNT STK reqs for $SCENARIO ($RUN_LABEL)" \
    || die "could not commit generated input"

# -- Baseline snapshot --------------------------------------------------------

BEFORE_JSON="$RESULTS_DIR/${RUN_LABEL}-before.json"
echo "[2/5] Capturing baseline snapshot -> $BEFORE_JSON"
python3 "$MEASURE_SCRIPT" --project-root project --label before \
    --emit-json "$BEFORE_JSON" --quiet \
    || die "baseline measurement failed"

# -- Invoke agent -------------------------------------------------------------

PROMPT_TEXT="$(cat "$PROMPT_FILE")"
PI_EXIT=0
T_START=$(date +%s)

if [ "$DRY_RUN" = "1" ]; then
    echo "[3/5] DRY_RUN=1 — skipping agent invocation."
    echo "Would have run: $PI_CMD <prompt-from-$PROMPT_FILE>"
else
    echo "[3/5] Invoking agent ($PI_CMD) ..."
    # Use timeout(1) if available; otherwise run directly.
    if command -v timeout >/dev/null 2>&1; then
        timeout --foreground "${TIMEOUT_SECONDS}s" "$PI_CMD" "$PROMPT_TEXT" || PI_EXIT=$?
    else
        "$PI_CMD" "$PROMPT_TEXT" || PI_EXIT=$?
    fi
fi

T_END=$(date +%s)
DURATION=$(( T_END - T_START ))
echo "Agent finished. Exit=$PI_EXIT, duration=${DURATION}s"

# -- Final snapshot -----------------------------------------------------------

AFTER_JSON="$RESULTS_DIR/${RUN_LABEL}-after.json"
echo "[4/5] Capturing final snapshot -> $AFTER_JSON"
python3 "$MEASURE_SCRIPT" --project-root project --label after \
    --emit-json "$AFTER_JSON" --quiet \
    || err "final measurement failed; check $AFTER_JSON"

# Annotate the after snapshot with run-level metadata.
python3 - "$AFTER_JSON" "$BEFORE_JSON" "$RUN_ID" "$SCENARIO" "$DURATION" "$PI_EXIT" "$BRANCH" "$PROMPT_FILE" <<'PY'
import json, sys
after_path, before_path, run_id, scenario, duration, pi_exit, branch, prompt_file = sys.argv[1:]
with open(after_path) as f:
    after = json.load(f)
after["benchmark_run"] = {
    "run_id": run_id,
    "scenario": scenario,
    "branch": branch,
    "prompt_file": prompt_file,
    "duration_seconds": int(duration),
    "agent_exit_code": int(pi_exit),
    "baseline_snapshot": before_path,
}
with open(after_path, "w") as f:
    json.dump(after, f, indent=2)
    f.write("\n")
PY

# -- Done --------------------------------------------------------------------

echo "[5/5] Snapshot summary:"
python3 - "$AFTER_JSON" <<'PY'
import json, sys
d = json.load(open(sys.argv[1]))
print(f"  total artifacts: {d.get('artifact_count_total', 0)}")
counts = d.get("artifact_counts", {})
for t in sorted(counts):
    print(f"    {t:25s} {counts[t]}")
v = d.get("validation", {})
print(f"  validation: errors={v.get('errors', 0)}, warnings={v.get('warnings', 0)}")
g2 = d.get("gates", {}).get("G2", {})
print(f"  G2 ready:   {g2.get('ready', False)}")
PY

echo
echo "Results saved to: $RESULTS_DIR"
echo "  $BEFORE_JSON"
echo "  $AFTER_JSON"
echo
echo "Aggregate across runs:  python3 .pi/benchmark/scripts/compare-runs.py --scenario $SCENARIO"

if [ "$PI_EXIT" -eq 124 ]; then
    exit 124
fi
exit "$PI_EXIT"
