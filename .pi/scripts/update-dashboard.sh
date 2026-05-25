#!/usr/bin/env bash
# =============================================================================
# V-Model XT — Dashboard Update Script
# Scans the project, updates status.json, and generates dashboard data.
# =============================================================================

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "${SCRIPT_DIR}/../.." && pwd)"

# Guard: refuse if project not initialized
source "${SCRIPT_DIR}/guard-init.sh"
STATUS_FILE="${PROJECT_ROOT}/dashboard/data/status.json"
TIMESTAMP=$(date -Iseconds)

echo "╔══════════════════════════════════════════════════════════════╗"
echo "║            V-Model XT — Dashboard Update                     ║"
echo "╚══════════════════════════════════════════════════════════════╝"
echo ""

# --- Scan function: count all non-hidden files, excluding archive/raw/trash ---
count_files() {
    local dir="$1"
    if [[ -d "${dir}" ]]; then
        find "${dir}" -type f ! -name '.*' ! -path '*/_Archiv/*' ! -path '*/_RAW/*' ! -path '*/_Trash/*' ! -name '.gitkeep' 2>/dev/null | wc -l
    else
        echo "0"
    fi
}

# Recursively count all MD files in a directory (excluding archive dirs)
count_md_files() {
    local dir="$1"
    if [[ -d "${dir}" ]]; then
        find "${dir}" -type f -name '*.md' ! -path '*/_Archiv/*' ! -path '*/_RAW/*' ! -path '*/_Trash/*' 2>/dev/null | wc -l
    else
        echo "0"
    fi
}

count_files_all() {
    local dir="$1"
    if [[ -d "${dir}" ]]; then
        find "${dir}" -type f ! -name '.*' ! -name '.gitkeep' 2>/dev/null | wc -l
    else
        echo "0"
    fi
}

# --- Scan each phase (recursive) ---
echo "Scanning project artifacts..."

# Requirements: count recursively in each subdirectory
REQS_STAKEHOLDER=$(count_md_files "${PROJECT_ROOT}/project/01_Requirements/01_StakeholderReqs")
REQS_SYSTEM=$(count_md_files "${PROJECT_ROOT}/project/01_Requirements/02_SystemReqs")
REQS_SW=$(count_md_files "${PROJECT_ROOT}/project/01_Requirements/03_SoftwareReqs")
REQS_HW=$(count_md_files "${PROJECT_ROOT}/project/01_Requirements/04_HardwareReqs")
REQS_USERNEEDS=$(count_md_files "${PROJECT_ROOT}/project/01_Requirements/00_UserNeeds")
REQS_RISKINPUTS=$(count_md_files "${PROJECT_ROOT}/project/01_Requirements/00_RiskInputs")

# Architecture: count recursively
ARCH_SYS=$(count_md_files "${PROJECT_ROOT}/project/02_Architecture/01_SystemArchitecture")
ARCH_SW=$(count_md_files "${PROJECT_ROOT}/project/02_Architecture/02_SoftwareArchitecture")
ARCH_HW=$(count_md_files "${PROJECT_ROOT}/project/02_Architecture/03_HardwareArchitecture")

DESIGN_SYS=$(count_md_files "${PROJECT_ROOT}/project/03_Design/01_SystemDesign")
DESIGN_SW=$(count_md_files "${PROJECT_ROOT}/project/03_Design/02_SoftwareDesign")
DESIGN_HW=$(count_md_files "${PROJECT_ROOT}/project/03_Design/03_HardwareDesign")

IMPL_SRC=$(count_files_all "${PROJECT_ROOT}/src")
IMPL_TESTS=$(find "${PROJECT_ROOT}/src" -path '*/tests/*' -type f ! -name '.gitkeep' 2>/dev/null | wc -l)

TEST_UNIT=$(count_md_files "${PROJECT_ROOT}/project/06_Verification/01_UnitTests")
TEST_INTEG=$(count_md_files "${PROJECT_ROOT}/project/06_Verification/02_IntegrationTests")
TEST_SYS=$(count_md_files "${PROJECT_ROOT}/project/06_Verification/03_SystemTests")
TEST_ARCH=$(count_md_files "${PROJECT_ROOT}/project/06_Verification/04_ArchitectureTests")

RISK_ANALYSIS=$(count_md_files "${PROJECT_ROOT}/project/08_RiskManagement/01_RiskAnalysis")
RISK_FMEA=$(count_md_files "${PROJECT_ROOT}/project/08_RiskManagement/02_FMEA")
RISK_FMEA_ROOT=$(find "${PROJECT_ROOT}/project/08_RiskManagement" -maxdepth 1 -name 'FMEA-*.md' -type f 2>/dev/null | wc -l)
RISK_FMEA=$((RISK_FMEA + RISK_FMEA_ROOT))
RISK_SAFETY=$(count_md_files "${PROJECT_ROOT}/project/08_RiskManagement/03_SafetyClassification")

INTEG_SW=$(count_md_files "${PROJECT_ROOT}/project/05_Integration/01_SoftwareIntegration")
INTEG_SYS=$(count_md_files "${PROJECT_ROOT}/project/05_Integration/02_SystemIntegration")

VALID_IQ=$(count_md_files "${PROJECT_ROOT}/project/07_Validation/00_InstallationQualification")
VALID_OQ=$(count_md_files "${PROJECT_ROOT}/project/07_Validation/01_OperationalQualification")
VALID_PQ=$(count_md_files "${PROJECT_ROOT}/project/07_Validation/02_PerformanceQualification")

REGULATORY=$(count_md_files "${PROJECT_ROOT}/project/09_Regulatory")
DOCUMENTATION=$(count_md_files "${PROJECT_ROOT}/project/10_Documentation")

PM=$(count_files "${PROJECT_ROOT}/project/00_ProjectManagement")

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
[[ -f "${PROJECT_ROOT}/project/01_Requirements/02_SystemReqs/SystemRequirements_SyRS.md" ]] && ((reqs_checklist+=1)) || true
[[ -f "${PROJECT_ROOT}/project/01_Requirements/03_SoftwareReqs/SoftwareRequirements_SRS.md" ]] && ((reqs_checklist+=1)) || true
[[ -f "${PROJECT_ROOT}/project/01_Requirements/RequirementsTraceabilityMatrix.md" ]] && ((reqs_checklist+=1)) || true

# Phase completion estimates (using actual file counts, with sensible thresholds)
# Each phase has an expected minimum number of files; completion = actual/expected * 100
TOTAL_REQS=$((REQS_STAKEHOLDER + REQS_SYSTEM + REQS_SW + REQS_HW + REQS_USERNEEDS + REQS_RISKINPUTS))
TOTAL_ARCH=$((ARCH_SYS + ARCH_SW + ARCH_HW))
TOTAL_DESIGN=$((DESIGN_SYS + DESIGN_SW + DESIGN_HW))
TOTAL_TESTS=$((TEST_UNIT + TEST_INTEG + TEST_SYS + TEST_ARCH))
TOTAL_RISK=$((RISK_ANALYSIS + RISK_FMEA + RISK_SAFETY))
TOTAL_VALID=$((VALID_IQ + VALID_OQ + VALID_PQ))
TOTAL_INTEG=$((INTEG_SW + INTEG_SYS))

PHASE_INIT_COMPL=$(calc_phase "$PM" 5)
PHASE_REQS_COMPL=$(calc_phase "$TOTAL_REQS" 5)
PHASE_ARCH_COMPL=$(calc_phase "$TOTAL_ARCH" 3)
PHASE_DESIGN_COMPL=$(calc_phase "$TOTAL_DESIGN" 3)
PHASE_IMPL_COMPL=$(calc_phase "$IMPL_SRC" 8)
PHASE_INTEG_COMPL=$(calc_phase "$TOTAL_INTEG" 3)
PHASE_VERIF_COMPL=$(calc_phase "$TOTAL_TESTS" 6)
PHASE_VALID_COMPL=$(calc_phase "$TOTAL_VALID" 3)
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
    'unit_test_files_md': ${TEST_UNIT},
    'verification_files': ${TEST_ARCH},
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

# Log activity
bash "${SCRIPT_DIR}/log-activity.sh" "dashboard-updater" "scanned-project" "Reqs:${REQS_SYSTEM} Arch:${ARCH_SYS} Src:${IMPL_SRC} Risk:${RISK_FMEA}" 2>/dev/null || true

echo ""
echo "Phase Status:"
python3 -c "
import json
with open('${STATUS_FILE}') as f:
    data = json.load(f)
print(f'  Total artifacts counted: requirements={${TOTAL_REQS}} architecture={${TOTAL_ARCH}} design={${TOTAL_DESIGN}} tests={${TOTAL_TESTS}} risk={${TOTAL_RISK}}')
for phase, info in data['phases'].items():
    bar = '█' * min(int(info['completion'] / 10), 10) + '░' * max(10 - int(info['completion'] / 10), 0)
    print(f'  {phase:25s} [{bar}] {info[\"status\"]:>12s} ({info[\"completion\"]:>3d}%)')
"
echo ""
