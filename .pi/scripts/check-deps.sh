#!/usr/bin/env bash
# =============================================================================
# V-Model XT — Dependency Check Script
# Verifies all required development tools and libraries are available.
# Usage: .pi/scripts/check-deps.sh [--json]
# =============================================================================
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "${SCRIPT_DIR}/../.." && pwd)"

OUTPUT_JSON=false
[ "${1:-}" = "--json" ] && OUTPUT_JSON=true

RED='\033[0;31m'; GREEN='\033[0;32m'; YELLOW='\033[1;33m'; NC='\033[0m'
PASS=0; WARN=0; FAIL=0
declare -a FAIL_DEPS=()
declare -a WARN_DEPS=()

check() {
    local name="$1"; local test_cmd="$2"; local advice="${3:-}"
    if eval "$test_cmd" 2>/dev/null; then
        $OUTPUT_JSON || echo -e "  ${GREEN}✓${NC} $name"
        PASS=$((PASS + 1))
    else
        $OUTPUT_JSON || echo -e "  ${RED}✗${NC} $name  ${YELLOW}→ $advice${NC}"
        FAIL=$((FAIL + 1))
        FAIL_DEPS+=("$name")
    fi
}

check_warn() {
    local name="$1"; local test_cmd="$2"; local advice="${3:-}"
    if eval "$test_cmd" 2>/dev/null; then
        $OUTPUT_JSON || echo -e "  ${GREEN}✓${NC} $name"
        PASS=$((PASS + 1))
    else
        $OUTPUT_JSON || echo -e "  ${YELLOW}⚠${NC} $name  ${YELLOW}→ $advice${NC}"
        WARN=$((WARN + 1))
        WARN_DEPS+=("$name")
    fi
}

if ! $OUTPUT_JSON; then
    echo "╔══════════════════════════════════════════════════════════════╗"
    echo "║          V-Model XT — Dependency Check                       ║"
    echo "╚══════════════════════════════════════════════════════════════╝"
    echo ""
fi

# ─── Build Tools (HARD FAIL) ────────────────────────────────────
$OUTPUT_JSON || echo "── Build Tools ──────────────────────────────────────────────"
check "cmake >= 3.16" '[ "$(cmake --version 2>/dev/null | head -1 | grep -oE "[0-9]+\.[0-9]+" | head -1 | tr -d .)" -ge 316 ]' \
      "Install: sudo apt install cmake / brew install cmake"
check "g++ (C++17)" 'echo "int main(){}" | g++ -std=c++17 -x c++ - -o /dev/null 2>/dev/null' \
      "Install: sudo apt install g++ build-essential"
check "make" 'command -v make >/dev/null 2>&1' \
      "Install: sudo apt install make"
check "pkg-config" 'command -v pkg-config >/dev/null 2>&1' \
      "Install: sudo apt install pkg-config"

# ─── C++ Libraries (WARN — can fetch online) ────────────────────
$OUTPUT_JSON || echo ""
$OUTPUT_JSON || echo "── C++ Libraries ────────────────────────────────────────────"
check_warn "SQLite3 dev" 'pkg-config --exists sqlite3 2>/dev/null || [ -f /usr/include/sqlite3.h ] || [ -f /usr/local/include/sqlite3.h ]' \
      "Install: sudo apt install libsqlite3-dev"
check_warn "nlohmann_json" 'pkg-config --exists nlohmann_json 2>/dev/null || [ -f /usr/include/nlohmann/json.hpp ] || [ -f /usr/local/include/nlohmann/json.hpp ]' \
      "Install: sudo apt install nlohmann-json3-dev  (or CMake will FetchContent)"
check_warn "tinyxml2" 'pkg-config --exists tinyxml2 2>/dev/null || [ -f /usr/include/tinyxml2.h ] || [ -f /usr/local/include/tinyxml2.h ]' \
      "Install: sudo apt install libtinyxml2-dev  (or CMake will FetchContent)"

# ─── Python ─────────────────────────────────────────────────────
$OUTPUT_JSON || echo ""
$OUTPUT_JSON || echo "── Python ───────────────────────────────────────────────────"
check "python3 >= 3.8" 'python3 -c "import sys; assert sys.version_info >= (3,8)" 2>/dev/null' \
      "Install: sudo apt install python3"
check_warn "tkinter (for sim GUI)" 'python3 -c "import tkinter" 2>/dev/null' \
      "Install: sudo apt install python3-tk  (or run simulation with --no-gui)"

# ─── Node.js ────────────────────────────────────────────────────
$OUTPUT_JSON || echo ""
$OUTPUT_JSON || echo "── Node.js (Electron GUI) ───────────────────────────────────"
check_warn "node >= 18" '[ "$(node -v 2>/dev/null | grep -oE "[0-9]+" | head -1)" -ge 18 ]' \
      "Install: nvm install 18  /  brew install node@18"
check_warn "npm" 'command -v npm >/dev/null 2>&1' \
      "Install: comes with Node.js"

# ─── Runtime Tools (WARN) ───────────────────────────────────────
$OUTPUT_JSON || echo ""
$OUTPUT_JSON || echo "── Runtime Tools ────────────────────────────────────────────"
check_warn "ss (port detection)" 'command -v ss >/dev/null 2>&1' \
      "Install: sudo apt install iproute2  (or script falls back to fuser)"
check_warn "fuser (port detection)" 'command -v fuser >/dev/null 2>&1' \
      "Install: sudo apt install psmisc"

# ─── Summary ────────────────────────────────────────────────────
if $OUTPUT_JSON; then
    echo "{\"pass\":$PASS,\"fail\":$FAIL,\"warn\":$WARN,\"failed\":$(python3 -c "import json; print(json.dumps($(declare -p FAIL_DEPS | cut -d= -f2-)))"),\"warnings\":$(python3 -c "import json; print(json.dumps($(declare -p WARN_DEPS | cut -d= -f2-)))")}"
else
    echo ""
    echo "══════════════════════════════════════════════════════════════"
    echo "  Results: ${GREEN}${PASS} passed${NC}, ${RED}${FAIL} failed${NC}, ${YELLOW}${WARN} warnings${NC}"
    if [ "$FAIL" -gt 0 ]; then
        echo ""
        echo "  CRITICAL: Install missing dependencies before building:"
        for dep in "${FAIL_DEPS[@]}"; do echo "    - $dep"; done
        echo ""
        echo "  On Ubuntu/Debian:"
        echo "    sudo apt install cmake g++ make pkg-config libsqlite3-dev python3"
        echo "  On macOS:"
        echo "    brew install cmake sqlite3 python3 node"
        exit 1
    fi
    if [ "$WARN" -gt 0 ]; then
        echo ""
        echo "  Warnings (optional but recommended):"
        for dep in "${WARN_DEPS[@]}"; do echo "    - $dep"; done
    fi
    echo "══════════════════════════════════════════════════════════════"
fi
