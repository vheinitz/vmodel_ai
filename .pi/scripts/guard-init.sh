#!/usr/bin/env bash
# =============================================================================
# V-Model XT — Initialization Guard
# Sources this script or call it directly to assert the project is initialized.
# Exits with code 2 and a helpful message if init has not been performed.
#
# Usage:
#   source "${SCRIPT_DIR}/guard-init.sh"   # Will exit if not initialized
#   bash "${SCRIPT_DIR}/guard-init.sh"     # Same, for non-sourced use
# =============================================================================

# Determine project root relative to this script
_guard_script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
_guard_project_root="$(cd "${_guard_script_dir}/../.." && pwd)"
_guard_project_json="${_guard_project_root}/dashboard/data/project.json"

_is_initialized() {
    if [[ ! -f "${_guard_project_json}" ]]; then
        return 1
    fi
    local init_date
    init_date=$(python3 -c "
import json
with open('${_guard_project_json}') as f:
    d = json.load(f)
print(d.get('project', {}).get('init_date', 'Not initialized'))
" 2>/dev/null)
    if [[ "${init_date}" != "Not initialized" && -n "${init_date}" ]]; then
        return 0
    fi
    return 1
}

if ! _is_initialized; then
    echo "╔══════════════════════════════════════════════════════════════╗"
    echo "║  ERROR: Project is not initialized.                         ║"
    echo "║                                                            ║"
    echo "║  Run the following command first:                          ║"
    echo "║    make init                                               ║"
    echo "║  or:                                                       ║"
    echo "║    bash .pi/scripts/init-project.sh                        ║"
    echo "╚══════════════════════════════════════════════════════════════╝"
    exit 2
fi
