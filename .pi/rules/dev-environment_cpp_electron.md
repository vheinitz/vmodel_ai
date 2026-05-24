# Rule: Development Environment Specification

## Purpose
Defines the required development environment for the HeliosAI project. Every developer (human or AI agent) MUST verify their environment against this spec before writing or building code. This prevents "works on my machine but not on yours" problems.

## When This Rule Applies
- **on C++ Electron stack** — this is a foundational rule checked before any phase work begins
- **Before any `make` or `./start.sh` invocation** — environment must be verified
- **When adding a new dependency** — update this rule
- **When onboarding a new developer** — they must pass all checks

---

## 1. Required Tools (HARD REQUIREMENTS)

All tools must be available on `$PATH`. Versions below are minimums.

| Tool | Min Version | Why Needed | Verify Command |
|------|------------|------------|----------------|
| **cmake** | 3.16 | Build system for C++ backend | `cmake --version` |
| **g++** or **clang++** | GCC 8+ / Clang 7+ | C++17 compilation | `g++ --version` |
| **make** | 4.0+ | Build orchestration | `make --version` |
| **pkg-config** | 0.29+ | Library detection | `pkg-config --version` |
| **python3** | 3.8+ | Simulation server, smoke tests, scripts | `python3 --version` |
| **node** | 18+ | Electron GUI runtime | `node --version` |
| **npm** | 8+ | Electron GUI package manager | `npm --version` |
| **git** | 2.0+ | FetchContent (CMake), version control | `git --version` |

## 2. Required Libraries

### 2.1 C++ Libraries (System or FetchContent)

| Library | Preferred Source | Fallback | Verify |
|---------|-----------------|----------|--------|
| **SQLite3** | System package (libsqlite3-dev) | N/A (required) | `pkg-config --exists sqlite3` or check for `sqlite3.h` |
| **nlohmann_json** | System package (nlohmann-json3-dev) | CMake FetchContent v3.11.3 | `pkg-config --exists nlohmann_json` |
| **tinyxml2** | System package (libtinyxml2-dev) | CMake FetchContent v10.0.0 | `pkg-config --exists tinyxml2` |
| **Google Test** | FetchContent v1.14.0 | System (libgtest-dev) | Only needed for `BUILD_TESTS=ON` |

### 2.2 Python Libraries (Built-in preferred)

| Library | Need | Verify |
|---------|------|--------|
| **tkinter** | Simulation GUI (optional) | `python3 -c "import tkinter"` |
| **json, socket, struct, threading** | All built-in | Always available |
| **Pillow** | gen_test_images.py (optional) | `python3 -c "from PIL import Image"` |

### 2.3 Node.js Packages (npm)

| Package | Version | Purpose |
|---------|---------|---------|
| **electron** | ^28.0.0 | GUI framework (devDependency) |

## 3. Platform Support

### 3.1 Primary Target
- **Linux x86_64** (Ubuntu 22.04 LTS or newer)

### 3.2 Secondary (best-effort)
- **macOS** (Apple Silicon via Rosetta / native)
- **Windows** (WSL2 only — not native Windows)

### 3.3 Not Supported
- Native Windows (no Win32 API bindings)
- 32-bit architectures
- ARM Linux (untested, may work)

## 4. Environment Variables

| Variable | Default | Purpose |
|----------|---------|---------|
| `SIM_PORT` | 9002 | Hardware simulation TCP port |
| `BACKEND_PORT` | 9001 | C++ backend TCP port |
| `SIM_IMAGE_DIR` | `./sample_images` | Directory for simulated camera images |
| `HELIOSAI_DATA_ROOT` | (unset, defaults to `/tmp`) | Root directory for run data |

None of these variables are required — all have sensible defaults.

## 5. Network Requirements

### 5.1 During Build
- Outbound HTTPS on port 443 (for CMake FetchContent, npm registry)
- Git protocol or HTTPS for FetchContent (github.com)

### 5.2 During Runtime
- Localhost TCP only (ports 9001, 9002)
- No outbound internet required at runtime

### 5.3 Offline Build
To build without internet:
1. Pre-install all system libraries (SQLite3, nlohmann_json, tinyxml2)
2. Pre-install Google Test (`sudo apt install libgtest-dev`)
3. Pre-populate npm cache or use `npm install --prefer-offline`
4. Use `cmake .. -DBUILD_TESTS=OFF` to skip FetchContent for GTest

## 6. Filesystem Requirements

| Path | Usage | Permissions | Notes |
|------|-------|------------|-------|
| `./04_Implementation/src/backend/build/` | Build artifacts | Read+Write+Execute | Created automatically |
| `/tmp/heliosai.db` | SQLite database | Read+Write | Wiped on restart unless `--keep-db` |
| `./04_Implementation/src/gui/node_modules/` | npm packages | Read | Created by `npm install` |
| `./04_Implementation/src/simulation/sample_images/` | Test images | Read+Write | Created automatically |

## 7. Verification Procedure

### 7.1 Automated (CI-friendly)
```bash
bash .pi/scripts/check-deps.sh --json
```
Returns JSON with pass/fail/warn counts. Zero failures = environment ready.

### 7.2 Manual (developer workstation)
```bash
bash .pi/scripts/check-deps.sh
```
Interactive output with install instructions for missing deps.

### 7.3 Full Integration Test
```bash
./start.sh --no-gui  # Start simulation + backend, skip Electron
# Wait for "HeliosAI is running" message
# Press Ctrl+C
```
If this succeeds without errors, the environment is fully functional.

## 8. Common Environment Pitfalls

### 8.1 "node-gyp" errors during npm install
**Cause:** Missing Python or C++ build tools for native npm modules.
**Fix:** `sudo apt install python3 make g++` (Electron itself rarely needs node-gyp, but its deps might)

### 8.2 "SUID sandbox helper" on Linux
**Cause:** Electron's sandbox requires special kernel permissions.
**Fix:** Already handled via `--no-sandbox` in main.js. For production builds, configure proper sandbox.

### 8.3 "FetchContent cannot clone" during cmake
**Cause:** Corporate firewall blocks git:// or https:// to GitHub.
**Fix:** Set git proxy: `git config --global http.proxy http://proxy:port` or pre-install libraries via system package manager.

### 8.4 "Permission denied" on /tmp/heliosai.db
**Cause:** Another user owns the file, or /tmp is mounted noexec.
**Fix:** `rm -f /tmp/heliosai.db` or use a different DB path via environment variable.

### 8.5 "Cannot find nlohmann/json.hpp" during compilation
**Cause:** CMake found nlohmann_json but the include path is wrong (common with system packages).
**Fix:** Check `cmake` output for `nlohmann_json_INCLUDE_DIRS`. If empty, install `nlohmann-json3-dev` explicitly.

## 9. Rule Maintenance

When adding a new dependency to the project:
1. Add it to this rule (Sections 1-2)
2. Add it to `.pi/scripts/check-deps.sh`
3. Update `.pi/skills/build-and-run.md` if it affects build process
4. Test on a clean environment (Docker container recommended)
5. Update CI pipeline if one exists
