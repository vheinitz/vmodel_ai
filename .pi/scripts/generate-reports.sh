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

# Embed reports data into JS for offline dashboard access
ARTIFACT_INDEX="${REPORTS_DIR}/artifacts/index.json"
LEGACY_INDEX="${REPORTS_DIR}/index.json"
EMBED_JS="${PROJECT_ROOT}/dashboard/js/panels/reports-data.js"
if [[ -f "${ARTIFACT_INDEX}" ]]; then
    python3 -c "
import json
with open('${ARTIFACT_INDEX}') as f:
    artifacts = json.load(f)
legacy = {}
legacy_path = '${LEGACY_INDEX}'
import os
if os.path.exists(legacy_path):
    with open(legacy_path) as f:
        legacy = json.load(f)
data = {
    'artifacts': artifacts.get('artifacts', []),
    'artifact_count': artifacts.get('artifact_count', 0),
    'generated': artifacts.get('generated', ''),
    'legacy_pages': legacy.get('pages', []),
}
js = 'var EMBEDDED_REPORTS_DATA = ' + json.dumps(data, indent=2) + ';'
with open('${EMBED_JS}', 'w') as f:
    f.write(js)
print(f'Embedded {len(data[\"artifacts\"])} artifacts + {len(data[\"legacy_pages\"])} legacy reports')
"
fi

# Log activity
ARTIFACT_COUNT=$(find "${REPORTS_DIR}/artifacts" -name '*.html' 2>/dev/null | wc -l)
bash "${SCRIPT_DIR}/log-activity.sh" "report-generator" "generated-reports" "${ARTIFACT_COUNT} HTML artifacts" 2>/dev/null || true
