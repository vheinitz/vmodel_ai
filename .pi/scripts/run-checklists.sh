#!/usr/bin/env bash
# =============================================================================
# V-Model XT — Checklist Runner Script
# Evaluates checklists for the current phase and reports status.
# =============================================================================

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "${SCRIPT_DIR}/../.." && pwd)"
STATUS_FILE="${PROJECT_ROOT}/dashboard/data/status.json"
RULES_DIR="${PROJECT_ROOT}/.pi/rules"
SKILLS_DIR="${PROJECT_ROOT}/.pi/skills"
TIMESTAMP=$(date -Iseconds)

echo "╔══════════════════════════════════════════════════════════════╗"
echo "║            V-Model XT — Checklist Evaluator                  ║"
echo "╚══════════════════════════════════════════════════════════════╝"
echo ""

# --- Determine current active phase ---
ACTIVE_PHASE=$(python3 -c "
import json
with open('${STATUS_FILE}') as f:
    data = json.load(f)
active = None
for phase, info in data['phases'].items():
    if info['status'] in ('in-progress', 'pending'):
        active = phase
        break
print(active or '00_project_initiation')
")

echo "Active Phase: ${ACTIVE_PHASE}"
echo ""

# --- Load and display the relevant checklist ---
case "${ACTIVE_PHASE}" in
    00_project_initiation)
        CHECKLIST_TITLE="Phase 0: Project Initiation Checklist"
        CHECKLIST_ITEMS=(
            "PMP created and approved"
            "Project organization defined"
            "Resource plan established"
            "Communication plan created"
            "Development environment specified"
            "Toolchain defined (VC, CI/CD, ITS)"
            "Regulatory strategy documented"
            "Software safety classification performed"
            "Risk management plan approved"
            "QA plan approved"
            "CM plan approved"
        )
        ;;
    01_requirements)
        CHECKLIST_TITLE="Phase 1: Requirements Analysis Checklist"
        CHECKLIST_ITEMS=(
            "Stakeholder requirements documented"
            "System requirements derived and baselined"
            "Software requirements derived and baselined"
            "Hardware requirements documented"
            "Interface requirements specified"
            "Performance requirements specified"
            "Safety requirements identified"
            "Regulatory requirements captured"
            "Usability requirements defined"
            "Traceability matrix established"
            "Requirements review completed"
            "All requirements have unique IDs"
            "All requirements are testable"
            "Ambiguous requirements resolved"
            "Conflicting requirements resolved"
            "Requirements change process defined"
        )
        ;;
    02_architecture)
        CHECKLIST_TITLE="Phase 2: Architecture Checklist"
        CHECKLIST_ITEMS=(
            "System architecture documented (SyAD)"
            "System decomposed into components"
            "Component interfaces specified"
            "Software architecture documented (SW-SAD)"
            "Architecture views documented (4+1)"
            "Data architecture defined"
            "SOUP identified and documented"
            "Architecture reviewed against requirements"
            "Architecture decisions documented (ADR)"
            "Safety-critical components identified"
            "Fault-tolerance mechanisms defined"
            "Performance and scalability assessed"
            "Security architecture defined"
        )
        ;;
    03_design)
        CHECKLIST_TITLE="Phase 3: Design Checklist"
        CHECKLIST_ITEMS=(
            "Detailed software design documented (SDD)"
            "Module/class design completed"
            "Database schema defined"
            "API specifications completed"
            "UI design completed"
            "Error handling design completed"
            "State machines defined"
            "Design patterns documented"
            "Design reviewed against architecture"
            "Testability of design confirmed"
            "Coding standards defined"
        )
        ;;
    04_implementation)
        CHECKLIST_TITLE="Phase 4: Implementation Checklist"
        CHECKLIST_ITEMS=(
            "All modules implemented"
            "Code follows coding standards"
            "Code documented (Doxygen)"
            "Unit tests for all modules"
            "Unit test coverage ≥ 80%"
            "Safety-critical code coverage = 100%"
            "Static analysis performed"
            "Code reviews completed"
            "Build system configured (CMake)"
            "CI/CD pipeline operational"
            "Technical debt tracked"
        )
        ;;
    05_integration)
        CHECKLIST_TITLE="Phase 5: Integration Checklist"
        CHECKLIST_ITEMS=(
            "Software components integrated"
            "Integration test plan created"
            "Integration tests executed"
            "All integration test cases passed"
            "Hardware-software integration tested"
            "External interfaces tested"
            "Database integration tested"
            "Performance benchmarks met"
            "Defects documented and tracked"
            "Regression tests passed"
            "Integration report completed"
        )
        ;;
    06_verification)
        CHECKLIST_TITLE="Phase 6: Verification Checklist"
        CHECKLIST_ITEMS=(
            "System test plan created"
            "System test cases linked to requirements"
            "All system tests executed"
            "Functional tests passed"
            "Performance tests passed"
            "Safety tests passed"
            "Regression tests passed"
            "Architecture compliance verified"
            "Traceability matrix complete"
            "Defect list reviewed and resolved"
            "Test report completed and reviewed"
            "Verification summary report signed"
        )
        ;;
    07_validation)
        CHECKLIST_TITLE="Phase 7: Validation Checklist (OQ/PQ)"
        CHECKLIST_ITEMS=(
            "Operational Qualification plan created"
            "OQ tests executed"
            "Performance Qualification plan created"
            "PQ tests executed"
            "User acceptance testing completed"
            "Risk management file reviewed"
            "Residual risks evaluated"
            "Intended use verified"
            "Labeling and user documentation reviewed"
            "Validation report completed"
            "Regulatory submission prepared"
        )
        ;;
    *)
        CHECKLIST_TITLE="General V-Model Checklist"
        CHECKLIST_ITEMS=("No specific checklist for this phase")
        ;;
esac

# --- Display Checklist ---
echo "══════════════════════════════════════════════════════════════"
echo "  ${CHECKLIST_TITLE}"
echo "══════════════════════════════════════════════════════════════"
echo ""

COMPLETED=0
TOTAL=${#CHECKLIST_ITEMS[@]}

for i in "${!CHECKLIST_ITEMS[@]}"; do
    # Check for evidence files (simplified heuristic)
    ITEM="${CHECKLIST_ITEMS[$i]}"
    CHECKED="[ ]"
    
    case "${ITEM}" in
        *"PMP"*)
            [[ -f "${PROJECT_ROOT}/project/00_ProjectManagement/01_ProjectPlan/PMP.md" ]] && CHECKED="[✓]" && ((COMPLETED+=1)) || true
            ;;
        *"requirements"*|*"Requirements"*|*"SRS"*|*"SyRS"*)
            [[ "$(find "${PROJECT_ROOT}/project/01_Requirements" -name "*.md" 2>/dev/null | wc -l)" -gt 0 ]] && CHECKED="[✓]" && ((COMPLETED+=1)) || true
            ;;
        *"architecture"*|*"Architecture"*|*"SAD"*|*"SyAD"*)
            [[ "$(find "${PROJECT_ROOT}/project/02_Architecture" -name "*.md" 2>/dev/null | wc -l)" -gt 0 ]] && CHECKED="[✓]" && ((COMPLETED+=1)) || true
            ;;
        *"design"*|*"Design"*|*"SDD"*)
            [[ "$(find "${PROJECT_ROOT}/project/03_Design" -name "*.md" 2>/dev/null | wc -l)" -gt 0 ]] && CHECKED="[✓]" && ((COMPLETED+=1)) || true
            ;;
        *"implemented"*|*"source"*|*"code"*|*"Code"*)
            [[ "$(find "${PROJECT_ROOT}/src" -type f ! -name '.gitkeep' 2>/dev/null | wc -l)" -gt 0 ]] && CHECKED="[✓]" && ((COMPLETED+=1)) || true
            ;;
        *"test"*|*"Test"*)
            [[ "$(find "${PROJECT_ROOT}/project/06_Verification" -name "*.md" 2>/dev/null | wc -l)" -gt 0 ]] && CHECKED="[✓]" && ((COMPLETED+=1)) || true
            ;;
        *"risk"*|*"Risk"*|*"FMEA"*)
            [[ "$(find "${PROJECT_ROOT}/project/08_RiskManagement" -name "*.md" 2>/dev/null | wc -l)" -gt 0 ]] && CHECKED="[✓]" && ((COMPLETED+=1)) || true
            ;;
        *)
            CHECKED="[?]"
            ;;
    esac
    
    printf "  %s %s\n" "${CHECKED}" "${ITEM}"
done

echo ""
PCT=$(( COMPLETED * 100 / TOTAL ))
echo "  Progress: ${COMPLETED}/${TOTAL} (${PCT}%)"
echo ""

# --- Generate next steps ---
echo "────────────────────────────────────────────────────────────"
echo "  Suggested Next Actions:"
echo "────────────────────────────────────────────────────────────"

NEXT_STEPS=()
case "${ACTIVE_PHASE}" in
    00_project_initiation)
        NEXT_STEPS=(
            "Create PMP document in project/00_ProjectManagement/01_ProjectPlan/PMP.md"
            "Define project organization and roles"
            "Perform software safety classification per IEC 62304"
            "Set up development toolchain (Git, CMake, CI/CD)"
        )
        ;;
    01_requirements)
        NEXT_STEPS=(
            "Document stakeholder requirements from input documents"
            "Derive system requirements and create SyRS"
            "Derive software requirements and create SRS"
            "Establish requirements traceability matrix"
        )
        ;;
    02_architecture)
        NEXT_STEPS=(
            "Create system architecture document (SyAD)"
            "Define component decomposition (AC/AD/AF)"
            "Specify CAN bus and LIS interfaces"
            "Document architecture decisions (ADR)"
        )
        ;;
    03_design)
        NEXT_STEPS=(
            "Create detailed software design (SDD)"
            "Define database schema"
            "Specify API contracts"
            "Design error handling and logging"
        )
        ;;
    04_implementation)
        NEXT_STEPS=(
            "Implement pending modules"
            "Write unit tests"
            "Run static analysis (clang-tidy, cppcheck)"
            "Review code for coding standard compliance"
        )
        ;;
    05_integration)
        NEXT_STEPS=(
            "Create integration test plan"
            "Execute software integration tests"
            "Perform hardware-software integration"
            "Document and track defects"
        )
        ;;
    06_verification)
        NEXT_STEPS=(
            "Create system test plan"
            "Execute functional tests"
            "Execute safety-related tests"
            "Complete traceability matrix"
        )
        ;;
    07_validation)
        NEXT_STEPS=(
            "Create OQ/PQ plans"
            "Execute validation in target environment"
            "Review risk management file"
            "Prepare regulatory submission"
        )
        ;;
esac

for step in "${NEXT_STEPS[@]}"; do
    echo "  → ${step}"
done

echo ""
echo "══════════════════════════════════════════════════════════════"
echo "  Checklist evaluation complete."
echo "  Run './scripts/trigger-agents.sh' for detailed AI analysis."
echo "══════════════════════════════════════════════════════════════"
