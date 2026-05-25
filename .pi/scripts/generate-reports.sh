#!/usr/bin/env bash
# =============================================================================
# V-Model XT — Report Generator
# Renders ALL project artifacts (MD → HTML) for dashboard display.
# Uses Python markdown library for proper conversion.
# Output goes to dashboard/data/reports/artifacts/
# =============================================================================
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "${SCRIPT_DIR}/../.." && pwd)"

# Guard: refuse if project not initialized
source "${SCRIPT_DIR}/guard-init.sh"
REPORTS_DIR="${PROJECT_ROOT}/dashboard/data/reports"
RENDERER="${SCRIPT_DIR}/render-artifacts.py"
TIMESTAMP=$(date -Iseconds)

mkdir -p "${REPORTS_DIR}"

echo "╔══════════════════════════════════════════════════════════════╗"
echo "║            V-Model XT — Report Generator                     ║"
echo "╚══════════════════════════════════════════════════════════════╝"
echo ""

echo "Rendering project artifacts to HTML..."
echo ""

# Use the Python renderer for proper MD→HTML conversion
if [[ -f "${RENDERER}" ]]; then
    python3 "${RENDERER}" \
        --project-root "${PROJECT_ROOT}" \
        --output-dir "${REPORTS_DIR}" \
        "$@"
else
    echo "ERROR: render-artifacts.py not found at ${RENDERER}" >&2
    exit 2
fi

echo ""
echo "✅ Reports generated in dashboard/data/reports/"
echo "   Open dashboard/index.html and browse the Reports panel."

# Log activity
ARTIFACT_COUNT=$(find "${REPORTS_DIR}/artifacts" -name '*.html' 2>/dev/null | wc -l)
bash "${SCRIPT_DIR}/log-activity.sh" "report-generator" "generated-reports" "${ARTIFACT_COUNT} HTML artifacts" 2>/dev/null || true
