#!/usr/bin/env bash
# =============================================================================
# V-Model XT — Agent Trigger Script
# Triggers all AI agents to analyze project state and suggest next actions.
# Each agent reads status.json, applies its skills/checklists, and updates the dashboard.
# =============================================================================

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "${SCRIPT_DIR}/../.." && pwd)"
STATUS_FILE="${PROJECT_ROOT}/dashboard/data/status.json"
AGENTS_DIR="${PROJECT_ROOT}/.pi/agents"
TIMESTAMP=$(date -Iseconds)

echo "╔══════════════════════════════════════════════════════════════╗"
echo "║            V-Model XT — Agent Analysis Trigger               ║"
echo "╚══════════════════════════════════════════════════════════════╝"
echo ""
echo "Project Root: ${PROJECT_ROOT}"
echo "Time:         ${TIMESTAMP}"
echo ""

# --- List of agents in execution order ---
AGENTS=(
    "project-manager"
    "requirements-engineer"
    "risk-manager"
    "system-architect"
    "software-architect"
    "developer"
    "tester"
    "qa-manager"
)

# Agents triggered on demand (not in regular cycle):
# innovation-manager, medical-domain-expert

# --- Helper: Update agent status in status.json ---
update_agent_status() {
    local agent="$1"
    local status="$2"
    local suggestions="$3"
    
    python3 -c "
import json, sys
try:
    with open('${STATUS_FILE}', 'r') as f:
        data = json.load(f)
    data['agents']['${agent}']['last_run'] = '${TIMESTAMP}'
    data['agents']['${agent}']['status'] = '${status}'
    data['agents']['${agent}']['suggestions'] = ${suggestions}
    data['last_update'] = '${TIMESTAMP}'
    with open('${STATUS_FILE}', 'w') as f:
        json.dump(data, f, indent=2)
except Exception as e:
    print(f'Error updating agent status: {e}', file=sys.stderr)
    sys.exit(1)
" 2>/dev/null || echo "Warning: Could not update agent status for ${agent}"
}

# --- Agent execution (simulated — in practice, this invokes the AI agent) ---
run_agent() {
    local agent="$1"
    local agent_file="${AGENTS_DIR}/${agent}.md"
    
    echo "────────────────────────────────────────────────────────────"
    echo "► Agent: ${agent}"
    echo "────────────────────────────────────────────────────────────"
    
    if [[ ! -f "${agent_file}" ]]; then
        echo "  ⚠ Agent config not found: ${agent_file}"
        update_agent_status "${agent}" "config_missing" "[]"
        return
    fi
    
    # In the AI harness context, this is where the agent would:
    # 1. Read the project state
    # 2. Apply its checklists/skills
    # 3. Analyze sources/docs
    # 4. Generate suggestions
    # For now, we record the trigger and mark as pending AI analysis
    
    echo "  Agent config: ${agent_file}"
    echo "  Status:       Awaiting AI analysis"
    echo ""
    
    # Mark as pending — results will be filled by the AI agent
    update_agent_status "${agent}" "pending" "[]"
}

# --- Main ---
echo "Current Phase Status:"
python3 -c "
import json
with open('${STATUS_FILE}') as f:
    data = json.load(f)
for phase, info in data['phases'].items():
    bar = '█' * int(info['completion'] / 10) + '░' * (10 - int(info['completion'] / 10))
    print(f'  {phase:25s} [{bar}] {info[\"status\"]:>12s} ({info[\"completion\"]:>3d}%)')
" 2>/dev/null || echo "  (Status data not yet available)"
echo ""

# Run each agent
for agent in "${AGENTS[@]}"; do
    run_agent "${agent}"
done

# --- Generate summary ---
echo ""
echo "══════════════════════════════════════════════════════════════"
echo "  Analysis Trigger Complete"
echo "  Run './scripts/update-dashboard.sh' to refresh the dashboard"
echo "══════════════════════════════════════════════════════════════"
