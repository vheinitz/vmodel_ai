#!/usr/bin/env bash
# Bootstrap smoke test for the V-Model XT template.
#
# Proves that a fresh copy of the repository:
#   1. Has no broken artifacts in `project/` (empty template = clean).
#   2. Has a clean seed example (`examples/coag-analyzer/`) that validates and reaches G2.
#   3. Will not be broken by a downstream consumer running `make validate` / `make gates`.
#
# The test copies the repo into a temporary directory and runs everything there,
# so the working tree is never mutated. Intended to run in CI on every PR.
#
# Exit codes:
#   0  template is healthy
#   1  something failed; see stderr/stdout

set -euo pipefail

REPO_ROOT="$(cd "$(dirname "$0")/../.." && pwd)"
TMPDIR="$(mktemp -d -t vmodel-bootstrap-XXXXXX)"
trap 'rm -rf "$TMPDIR"' EXIT

echo "Bootstrap test"
echo "=============="
echo "Source:  $REPO_ROOT"
echo "Sandbox: $TMPDIR"
echo

# 1. Copy template into sandbox (excluding .git and any local junk).
echo "[1/4] Copying template to sandbox..."
# Use tar to copy with exclusions; avoids depending on rsync.
(
    cd "$REPO_ROOT"
    tar \
        --exclude='.git' \
        --exclude='node_modules' \
        --exclude='*.bak' \
        --exclude='dashboard/data/*.bak' \
        -cf - . \
    | (cd "$TMPDIR" && tar -xf -)
)

# 2. Empty project/ should validate clean.
echo "[2/4] Validating empty project/ (expect 0 errors)..."
python3 "$TMPDIR/.pi/scripts/validate-artifacts.py" "$TMPDIR/project" --quiet \
    > "$TMPDIR/validate-project.out" 2>&1 || {
        echo "FAILED: validator returned non-zero on empty project/"
        cat "$TMPDIR/validate-project.out"
        exit 1
    }

# 3. Seed example must validate clean.
echo "[3/4] Validating examples/coag-analyzer/ (expect 0 errors)..."
python3 "$TMPDIR/.pi/scripts/validate-artifacts.py" \
    "$TMPDIR/examples/coag-analyzer/project" --quiet \
    > "$TMPDIR/validate-example.out" 2>&1 || {
        echo "FAILED: validator returned non-zero on seed example"
        cat "$TMPDIR/validate-example.out"
        exit 1
    }

# 4. Seed example must report G2 as ready.
echo "[4/4] Checking gate G2 on seed example (expect READY)..."
G2_OUT="$TMPDIR/gates-example.out"
python3 "$TMPDIR/.pi/scripts/check-gates.py" \
    "$TMPDIR/examples/coag-analyzer/project" --gate G2 --quiet \
    --emit-json "$TMPDIR/gates.json" > "$G2_OUT" 2>&1
G2_EXIT=$?
if [ $G2_EXIT -ne 0 ]; then
    echo "FAILED: gate engine returned non-zero on seed example"
    cat "$G2_OUT"
    cat "$TMPDIR/gates.json" 2>/dev/null || true
    exit 1
fi

# Inspect gates.json to confirm G2 ready=true (defensive — exit 0 already implies it).
python3 - <<EOF
import json, sys
data = json.load(open("$TMPDIR/gates.json"))
g2 = next((g for g in data["gates"] if g["gate"] == "G2"), None)
if not g2:
    print("FAILED: G2 missing from gates.json"); sys.exit(1)
if not g2["ready"]:
    print(f"FAILED: G2 not ready: {g2['blockers']}"); sys.exit(1)
print("G2 confirmed ready in gates.json.")
EOF

echo
echo "Bootstrap test PASSED."
