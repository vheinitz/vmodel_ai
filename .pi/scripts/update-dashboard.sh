#!/usr/bin/env bash
# =============================================================================
# V-Model XT — Dashboard Update Script
# Scans the project, updates status.json, and generates dashboard data.
# =============================================================================

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "${SCRIPT_DIR}/../.." && pwd)"
STATUS_FILE="${PROJECT_ROOT}/dashboard/data/status.json"
TIMESTAMP=$(date -Iseconds)

echo "╔══════════════════════════════════════════════════════════════╗"
echo "║            V-Model XT — Dashboard Update                     ║"
echo "╚══════════════════════════════════════════════════════════════╝"
echo ""

# --- Scan function: count files in a directory ---
count_files() {
    local dir="$1"
    if [[ -d "${dir}" ]]; then
        find "${dir}" -type f ! -path '*/\.*' ! -path '*/_Archiv/*' ! -path '*/_RAW/*' ! -path '*/_Trash/*' 2>/dev/null | wc -l
    else
        echo "0"
    fi
}

count_files_all() {
    local dir="$1"
    if [[ -d "${dir}" ]]; then
        find "${dir}" -type f ! -path '*/\.*' 2>/dev/null | wc -l
    else
        echo "0"
    fi
}

# --- Scan each phase ---
echo "Scanning project artifacts..."

REQS_STAKEHOLDER=$(count_files "${PROJECT_ROOT}/01_Requirements/01_StakeholderReqs")
REQS_SYSTEM=$(count_files "${PROJECT_ROOT}/01_Requirements/02_SystemReqs")
REQS_SW=$(count_files "${PROJECT_ROOT}/01_Requirements/03_SoftwareReqs")
REQS_HW=$(count_files "${PROJECT_ROOT}/01_Requirements/04_HardwareReqs")

ARCH_SYS=$(count_files "${PROJECT_ROOT}/02_Architecture/01_SystemArchitecture")
ARCH_SW=$(count_files "${PROJECT_ROOT}/02_Architecture/02_SoftwareArchitecture")
ARCH_HW=$(count_files "${PROJECT_ROOT}/02_Architecture/03_HardwareArchitecture")

DESIGN_SYS=$(count_files "${PROJECT_ROOT}/03_Design/01_SystemDesign")
DESIGN_SW=$(count_files "${PROJECT_ROOT}/03_Design/02_SoftwareDesign")

IMPL_SRC=$(count_files_all "${PROJECT_ROOT}/04_Implementation/src")
IMPL_TESTS=$(count_files_all "${PROJECT_ROOT}/04_Implementation/01_UnitTests")

TEST_UNIT=$(count_files "${PROJECT_ROOT}/06_Verification/01_UnitTests")
TEST_INTEG=$(count_files "${PROJECT_ROOT}/06_Verification/02_IntegrationTests")
TEST_SYS=$(count_files "${PROJECT_ROOT}/06_Verification/03_SystemTests")

RISK_ANALYSIS=$(count_files "${PROJECT_ROOT}/08_RiskManagement/01_RiskAnalysis")
RISK_FMEA=$(count_files "${PROJECT_ROOT}/08_RiskManagement/02_FMEA")

PM=$(count_files "${PROJECT_ROOT}/00_ProjectManagement")

# --- Calculate completion percentages ---
calc_phase() {
    local files=$1
    local expected=$2
    local weight=${3:-1.0}
    
    if [[ "$expected" -eq 0 ]]; then
        echo "0"
    else
        local pct=$(( files * 100 * 10 / expected / 10 ))
        if [[ "$pct" -gt 100 ]]; then pct=100; fi
        echo "$pct"
    fi
}

# Determine phase status
get_status() {
    local completion=$1
    if [[ "$completion" -eq 0 ]]; then echo "pending"
    elif [[ "$completion" -ge 100 ]]; then echo "completed"
    elif [[ "$completion" -ge 50 ]]; then echo "in-progress"
    else echo "in-progress"; fi
}

# Count checklists done (simplified: check if files exist with expected names)
reqs_checklist=0
[[ -f "${PROJECT_ROOT}/01_Requirements/02_SystemReqs/SystemRequirements_SyRS.md" ]] && ((reqs_checklist+=1)) || true
[[ -f "${PROJECT_ROOT}/01_Requirements/03_SoftwareReqs/SoftwareRequirements_SRS.md" ]] && ((reqs_checklist+=1)) || true
[[ -f "${PROJECT_ROOT}/01_Requirements/RequirementsTraceabilityMatrix.md" ]] && ((reqs_checklist+=1)) || true

# Phase completion estimates
PHASE_INIT_COMPL=$(calc_phase "$PM" 5 1.0)
PHASE_REQS_COMPL=$(calc_phase $((REQS_STAKEHOLDER + REQS_SYSTEM + REQS_SW)) 3 1.0)
PHASE_ARCH_COMPL=$(calc_phase $((ARCH_SYS + ARCH_SW)) 2 1.0)
PHASE_DESIGN_COMPL=$(calc_phase $((DESIGN_SYS + DESIGN_SW)) 2 1.0)
PHASE_IMPL_COMPL=$(calc_phase "$IMPL_SRC" 10 1.0)
PHASE_INTEG_COMPL=$(calc_phase "$TEST_INTEG" 3 1.0)
PHASE_VERIF_COMPL=$(calc_phase $((TEST_UNIT + TEST_SYS)) 5 1.0)
PHASE_VALID_COMPL=0  # late phase
PHASE_RELEASE_COMPL=0
PHASE_MAINT_COMPL=0

# --- Update status.json ---
python3 -c "
import json

with open('${STATUS_FILE}', 'r') as f:
    data = json.load(f)

data['last_update'] = '${TIMESTAMP}'

# Update phase statuses with actual file counts
data['phases']['00_project_initiation']['completion'] = ${PHASE_INIT_COMPL}
data['phases']['00_project_initiation']['status'] = '$(get_status ${PHASE_INIT_COMPL})'

data['phases']['01_requirements']['completion'] = ${PHASE_REQS_COMPL}
data['phases']['01_requirements']['status'] = '$(get_status ${PHASE_REQS_COMPL})'
data['phases']['01_requirements']['checklist_done'] = ${reqs_checklist}

data['phases']['02_architecture']['completion'] = ${PHASE_ARCH_COMPL}
data['phases']['02_architecture']['status'] = '$(get_status ${PHASE_ARCH_COMPL})'

data['phases']['03_design']['completion'] = ${PHASE_DESIGN_COMPL}
data['phases']['03_design']['status'] = '$(get_status ${PHASE_DESIGN_COMPL})'

data['phases']['04_implementation']['completion'] = ${PHASE_IMPL_COMPL}
data['phases']['04_implementation']['status'] = '$(get_status ${PHASE_IMPL_COMPL})'

data['phases']['05_integration']['completion'] = ${PHASE_INTEG_COMPL}
data['phases']['05_integration']['status'] = '$(get_status ${PHASE_INTEG_COMPL})'

data['phases']['06_verification']['completion'] = ${PHASE_VERIF_COMPL}
data['phases']['06_verification']['status'] = '$(get_status ${PHASE_VERIF_COMPL})'

data['phases']['07_validation']['completion'] = ${PHASE_VALID_COMPL}
data['phases']['07_validation']['status'] = 'pending'

data['phases']['08_release']['completion'] = ${PHASE_RELEASE_COMPL}
data['phases']['08_release']['status'] = 'pending'

data['phases']['09_maintenance']['completion'] = ${PHASE_MAINT_COMPL}
data['phases']['09_maintenance']['status'] = 'pending'

# Artifact counts
data['artifact_counts'] = {
    'stakeholder_reqs': ${REQS_STAKEHOLDER},
    'system_reqs': ${REQS_SYSTEM},
    'software_reqs': ${REQS_SW},
    'hardware_reqs': ${REQS_HW},
    'system_arch': ${ARCH_SYS},
    'software_arch': ${ARCH_SW},
    'hardware_arch': ${ARCH_HW},
    'system_design': ${DESIGN_SYS},
    'software_design': ${DESIGN_SW},
    'source_files': ${IMPL_SRC},
    'unit_test_files': ${IMPL_TESTS},
    'verification_files': ${TEST_UNIT},
    'integration_test_files': ${TEST_INTEG},
    'system_test_files': ${TEST_SYS},
    'risk_docs': ${RISK_ANALYSIS},
    'fmea_docs': ${RISK_FMEA},
    'project_mgmt': ${PM}
}

with open('${STATUS_FILE}', 'w') as f:
    json.dump(data, f, indent=2)
"

echo ""
echo "✅ Dashboard data updated successfully!"
echo ""
echo "Phase Status:"
python3 -c "
import json
with open('${STATUS_FILE}') as f:
    data = json.load(f)
for phase, info in data['phases'].items():
    bar = '█' * min(int(info['completion'] / 10), 10) + '░' * max(10 - int(info['completion'] / 10), 0)
    print(f'  {phase:25s} [{bar}] {info[\"status\"]:>12s} ({info[\"completion\"]:>3d}%)')
"
echo ""

# --- Embed status.json into dashboard HTML for file:// viewing ---
DASHBOARD="${PROJECT_ROOT}/dashboard/index.html"
if [[ -f "${DASHBOARD}" && -f "${STATUS_FILE}" ]]; then
    python3 - "$STATUS_FILE" "$DASHBOARD" << 'PYEOF'
import json, re, sys
status_file = sys.argv[1]
dashboard_file = sys.argv[2]
status = json.load(open(status_file))
status_json = json.dumps(status)
with open(dashboard_file, "r") as f:
    html = f.read()
html = re.sub(r'<script id="embedded-status-data"[^>]*>.*?</script>', '', html, flags=re.DOTALL)
new_block = '<script id="embedded-status-data" type="application/json">' + status_json + '</script>'
html = html.replace('</body>', new_block + '\n</body>')
with open(dashboard_file, "w") as f:
    f.write(html)
print('  Dashboard HTML embedded with live status data.')
PYEOF
fi
