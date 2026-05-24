#!/usr/bin/env bash
# =============================================================================
# V-Model XT — Activity History Tracker
# Appends an activity entry to dashboard/data/history.json
# Usage: .pi/scripts/log-activity.sh "agent-name" "action" "details"
# =============================================================================
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "${SCRIPT_DIR}/../.." && pwd)"
HISTORY_FILE="${PROJECT_ROOT}/dashboard/data/history.json"
TIMESTAMP=$(date -Iseconds)

AGENT="${1:-unknown}"
ACTION="${2:-action}"
DETAILS="${3:-}"

mkdir -p "$(dirname "${HISTORY_FILE}")"

python3 -c "
import json, sys, os

history_file = '${HISTORY_FILE}'
timestamp = '${TIMESTAMP}'
agent = '${AGENT}'
action = '${ACTION}'
details = '${DETAILS}'

# Load or create history
if os.path.exists(history_file):
    with open(history_file) as f:
        try:
            data = json.load(f)
        except json.JSONDecodeError:
            data = {'activities': [], 'last_activity_id': 0}
else:
    data = {'activities': [], 'last_activity_id': 0}

activity_id = data['last_activity_id'] + 1
data['last_activity_id'] = activity_id

entry = {
    'id': activity_id,
    'timestamp': timestamp,
    'agent': agent,
    'action': action,
    'details': details
}

data['activities'].append(entry)

# Keep max 500 entries
if len(data['activities']) > 500:
    data['activities'] = data['activities'][-500:]

with open(history_file, 'w') as f:
    json.dump(data, f, indent=2)

print(f'Activity #{activity_id} logged: [{agent}] {action}')
" 2>/dev/null || echo "Warning: Failed to log activity"
