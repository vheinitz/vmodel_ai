#!/usr/bin/env bash
# =============================================================================
# V-Model XT — Project Initialization Script
# Initializes a new project from the template with project-specific values
# =============================================================================

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "${SCRIPT_DIR}/../.." && pwd)"

echo "╔══════════════════════════════════════════════════════════════╗"
echo "║       V-Model XT Medical Device Project Initializer         ║"
echo "╚══════════════════════════════════════════════════════════════╝"
echo ""

# --- Configuration ---
read -rp "Project Number (e.g., PRJ001): " PROJECT_NUMBER
read -rp "Project Name (e.g., MyLabDevice): " PROJECT_NAME
read -rp "Product Description: " PRODUCT_DESC
read -rp "Regulatory Class (A/B/C per IEC 62304): " SAFETY_CLASS
read -rp "Component codes (space-separated, e.g. 'GUI CTRL FW'): " COMPONENTS

TIMESTAMP=$(date +%Y-%m-%d)
INIT_DATE="${TIMESTAMP}"

# --- Validate ---
if [[ -z "$PROJECT_NUMBER" || -z "$PROJECT_NAME" || -z "$SAFETY_CLASS" ]]; then
    echo "ERROR: Project number, name, and safety class are required."
    exit 1
fi

if [[ ! "$SAFETY_CLASS" =~ ^[ABC]$ ]]; then
    echo "ERROR: Safety class must be A, B, or C."
    exit 1
fi

# --- Create project config ---
CONFIG_DIR="${PROJECT_ROOT}/dashboard/data"
mkdir -p "${CONFIG_DIR}"

cat > "${CONFIG_DIR}/project.json" << EOF
{
  "project": {
    "number": "${PROJECT_NUMBER}",
    "name": "${PROJECT_NAME}",
    "description": "${PRODUCT_DESC}",
    "safety_class": "${SAFETY_CLASS}",
    "components": "${COMPONENTS:-GUI CTRL FW}",
    "standards": ["IEC 62304:2006+AMD1:2015", "ISO 14971:2019", "ISO 13485:2016", "IVDR (EU) 2017/746"],
    "init_date": "${INIT_DATE}",
    "last_updated": "${INIT_DATE}"
  }
}
EOF

# --- Initialize status ---
cat > "${CONFIG_DIR}/status.json" << EOF
{
  "project": "${PROJECT_NAME}",
  "number": "${PROJECT_NUMBER}",
  "safety_class": "${SAFETY_CLASS}",
  "last_update": "${TIMESTAMP}",
  "phases": {
    "00_project_initiation": { "status": "in-progress", "completion": 0, "checklist_total": 11, "checklist_done": 0 },
    "01_requirements":     { "status": "pending",    "completion": 0, "checklist_total": 18, "checklist_done": 0 },
    "02_architecture":     { "status": "pending",    "completion": 0, "checklist_total": 15, "checklist_done": 0 },
    "03_design":           { "status": "pending",    "completion": 0, "checklist_total": 12, "checklist_done": 0 },
    "04_implementation":   { "status": "pending",    "completion": 0, "checklist_total": 12, "checklist_done": 0 },
    "05_integration":      { "status": "pending",    "completion": 0, "checklist_total": 11, "checklist_done": 0 },
    "06_verification":     { "status": "pending",    "completion": 0, "checklist_total": 13, "checklist_done": 0 },
    "07_validation":       { "status": "pending",    "completion": 0, "checklist_total": 11, "checklist_done": 0 },
    "08_release":          { "status": "pending",    "completion": 0, "checklist_total": 9,  "checklist_done": 0 },
    "09_maintenance":      { "status": "pending",    "completion": 0, "checklist_total": 8,  "checklist_done": 0 }
  },
  "decision_gates": {
    "G1_project_approved": false,
    "G2_requirements_baselined": false,
    "G3_architecture_defined": false,
    "G4_design_completed": false,
    "G5_implementation_done": false,
    "G6_integration_done": false,
    "G7_verification_done": false,
    "G8_validation_done": false,
    "G9_project_completed": false
  },
  "metrics": {
    "total_requirements": 0,
    "requirements_with_tests": 0,
    "total_risk_items": 0,
    "risk_items_controlled": 0,
    "total_test_cases": 0,
    "test_cases_passed": 0,
    "test_cases_failed": 0,
    "code_coverage_percent": 0.0,
    "open_defects": 0,
    "resolved_defects": 0
  },
  "agents": {
    "project-manager":       { "last_run": null, "status": "idle", "suggestions": [] },
    "requirements-engineer": { "last_run": null, "status": "idle", "suggestions": [] },
    "system-architect":      { "last_run": null, "status": "idle", "suggestions": [] },
    "software-architect":    { "last_run": null, "status": "idle", "suggestions": [] },
    "developer":             { "last_run": null, "status": "idle", "suggestions": [] },
    "tester":                { "last_run": null, "status": "idle", "suggestions": [] },
    "risk-manager":          { "last_run": null, "status": "idle", "suggestions": [] },
    "qa-manager":            { "last_run": null, "status": "idle", "suggestions": [] }
  }
}
EOF

# --- Create initial project README ---
cat > "${PROJECT_ROOT}/README.md" << EOF
# ${PROJECT_NAME} — Medical Laboratory Automation Device

**Project Number:** ${PROJECT_NUMBER}  
**Safety Class:** ${SAFETY_CLASS} (IEC 62304)  
**Initialized:** ${INIT_DATE}  

## Description
${PRODUCT_DESC}

## Components
${COMPONENTS:-GUI CTRL FW}

## Project Status
View the [Project Dashboard](dashboard/index.html) for current status.

## Quick Links
- [Source Code](src/)
- [Project Management](project/00_ProjectManagement/)
- [Requirements](project/01_Requirements/)
- [Architecture](project/02_Architecture/)
- [Design](project/03_Design/)
- [Test & Verification](project/06_Verification/)
- [Risk Management](project/08_RiskManagement/)
- [Regulatory](project/09_Regulatory/)
- [Documentation](project/10_Documentation/)
EOF

echo ""
echo "✅ Project '${PROJECT_NAME}' (${PROJECT_NUMBER}) initialized successfully!"
echo "   Safety Class: ${SAFETY_CLASS}"
echo "   Location:     ${PROJECT_ROOT}"
echo ""
echo "Next steps:"
echo "   1. git init && git add -A && git commit -m 'Initial project'"
echo "   2. Place existing documents/code in project directories"
echo "   3. Run 'make all' to get AI agent analysis and suggestions"
echo "   4. Open 'dashboard/index.html' to view the project dashboard"
echo ""
