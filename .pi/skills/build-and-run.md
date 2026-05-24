# Skill: Build, Run & Environment Verification

## Purpose
Ensure the project can be built and run successfully on any supported platform. This skill provides a systematic checklist for verifying the development environment, building all components, and diagnosing common failures. It prevents the most frequent causes of "it doesn't compile" / "it doesn't start" issues.

## Scope
This skill covers:
- Development environment prerequisite verification
- Build process for C++ backend, Python simulation, and Electron GUI
- Runtime startup verification
- Common failure modes and their solutions

## When to Use This Skill
- **Before any implementation work** — verify the environment is ready
- **After cloning a fresh repository** — ensure all deps are installed
- **When adding new dependencies** — re-verify the build
- **When build/startup fails** — diagnostic mode
- **Before merging to main** — CI readiness check
- **During code review** — reviewer verifies the branch builds

---

## Phase 1: Environment Verification

### 1.1 Run Automated Check
```bash
bash .pi/scripts/check-deps.sh
```
This verifies: cmake, g++/clang++, make, pkg-config, SQLite3, nlohmann_json, tinyxml2, python3, tkinter, node, npm, ss/fuser.

### 1.2 Manual Checks (not covered by script)
- [ ] **Disk space**: ≥ 2 GB free for build artifacts + node_modules
- [ ] **Network access**: Required for FetchContent (tinyxml2, googletest, nlohmann_json fallback) and npm install
- [ ] **File permissions**: Write access to project directory and /tmp
- [ ] **No conflicting processes**: Ports 9001, 9002 free (check with `ss -ltn` or `fuser`)
- [ ] **Linux**: `vm.max_map_count` ≥ 65530 (for Electron: `sysctl vm.max_map_count`)

### 1.3 Platform-Specific Prerequisites

| Distro | Install Command |
|--------|----------------|
| **Ubuntu/Debian** | `sudo apt install cmake g++ make pkg-config libsqlite3-dev nlohmann-json3-dev libtinyxml2-dev python3 python3-tk` |
| **Fedora/RHEL** | `sudo dnf install cmake gcc-c++ make pkgconfig sqlite-devel json-devel tinyxml2-devel python3 python3-tkinter` |
| **Arch Linux** | `sudo pacman -S cmake gcc make pkgconf sqlite nlohmann-json tinyxml2 python tk` |
| **macOS** | `brew install cmake sqlite3 nlohmann-json tinyxml2 python-tk node` |
| **Windows (WSL2)** | Same as Ubuntu/Debian + ensure WSL2 has network access |

---

## Phase 2: Build Verification

### 2.1 C++ Backend Build
```bash
cd 04_Implementation/src/backend
mkdir -p build && cd build
cmake .. -DBUILD_TESTS=OFF
make -j$(nproc)
```
**Verify:** Binary `heliosai_backend` exists and is executable.

**Common failures:**

| Symptom | Likely Cause | Fix |
|---------|-------------|-----|
| `cmake: command not found` | cmake not installed | Install cmake ≥ 3.16 |
| `SQLite3 not found` | sqlite3-dev missing | `sudo apt install libsqlite3-dev` |
| `nlohmann_json not found` | json dev library missing | Install nlohmann-json3-dev OR let FetchContent download it |
| `tinyxml2 not found` | tinyxml2 missing | Install libtinyxml2-dev OR let FetchContent download |
| `FetchContent fails` | No internet / git not installed | Install git + ensure network OR pre-install deps |
| `#include <nlohmann/json.hpp> not found` | Wrong include path | Check cmake output for nlohmann include dirs |
| `C++17 not supported` | GCC < 8 or Clang < 7 | Upgrade compiler |
| `linker errors` | Missing library linkage | Check CMakeLists.txt target_link_libraries |

### 2.2 Unit Test Build
```bash
cd 04_Implementation/src/backend/build
cmake .. -DBUILD_TESTS=ON
make -j$(nproc)
ctest --output-on-failure
```
**Verify:** All tests pass. If tests fail, read the failure output.

**Common failures:**

| Symptom | Fix |
|---------|-----|
| `test_workflow_engine.cpp: 'std::ofstream' not found` | Missing `#include <fstream>` — add to test file |
| `googletest FetchContent fails` | No internet — install libgtest-dev: `sudo apt install libgtest-dev` |
| Tests compile but crash | Check database path permissions, file I/O |

### 2.3 Electron GUI Setup
```bash
cd 04_Implementation/src/gui
npm install
npm start  # launches Electron
```
**Verify:** Electron window opens without errors, shows login screen.

**Common failures:**

| Symptom | Fix |
|---------|-----|
| `electron: command not found` | Use `npx electron` — the `scripts.start` in package.json should use `npx electron` |
| `electron` installed globally, not locally | Move `electron` from `dependencies` to `devDependencies` in package.json |
| `sandbox` error on Linux | `--no-sandbox` flag already set in main.js — if error persists: `sudo sysctl -w kernel.unprivileged_userns_clone=1` |
| `GPU process` errors | `--disable-gpu` already set in main.js |
| `SUID sandbox` error | Use `--no-sandbox` (development only — not for production!) |
| `npm install` hangs | Check network, use `npm install --prefer-offline` if cached |
| `node_modules` takes too much space | Expected: ~400MB for Electron; clean with `rm -rf node_modules` if needed |

---

## Phase 3: Runtime Verification

### 3.1 Full Stack Start
```bash
./start.sh
```
This launches: Simulation (port 9002) → Backend (port 9001) → GUI (Electron window)

### 3.2 Component-by-Component Start (for debugging)
```bash
# Terminal 1: Simulation
cd 04_Implementation/src/simulation
python3 sim_main.py --port 9002

# Terminal 2: Backend (after simulation is ready)
cd 04_Implementation/src/backend/build
./heliosai_backend

# Terminal 3: GUI (after backend is ready)
cd 04_Implementation/src/gui
npm start
```

### 3.3 API Smoke Test (manual)
```bash
# Test with Python (no external deps)
python3 -c "
import socket,struct,json
s=socket.socket();s.settimeout(3)
s.connect(('127.0.0.1',9001))
r=json.dumps({'jsonrpc':'2.0','id':1,'method':'system.get_status','params':{}}).encode()
s.sendall(struct.pack('>I',len(r))+r)
print(json.loads(s.recv(struct.unpack('>I',s.recv(4))[0])))
"
# Expected: {'jsonrpc':'2.0','id':1,'result':{'backend_version':'0.1.0','database':True,...}}
```

### 3.4 Common Runtime Failures

| Symptom | Likely Cause | Fix |
|---------|-------------|-----|
| `Address already in use` on port 9001/9002 | Previous instance still running | `./start.sh` auto-cleans; manual: `fuser -k 9001/tcp` |
| Backend starts but GUI shows "Disconnected" | Backend not listening on 127.0.0.1:9001 | Check `main.cpp` IPC server port |
| `database: False` in smoke test | /tmp/heliosai.db not writable | Check permissions on /tmp |
| `auth.login` fails | Default users not created | Backend creates on first start; check schema SQL in main.cpp |
| Simulation GUI won't open | tkinter not installed | `sudo apt install python3-tk` or use `--no-gui` |
| `import tkinter` fails in Python | Wrong Python, venv without tk | Use system Python3 (not venv) for simulation GUI |
| Electron shows blank white window | renderer crashed | Open DevTools: Ctrl+Shift+I → check Console tab |
| `Error: Cannot find module 'electron'` | npm install incomplete | `cd gui && rm -rf node_modules && npm install` |

---

## Phase 4: Protocol Compatibility Check

### 4.1 Verify JSON-RPC Consistency
- **Backend** uses JSON-RPC 2.0: `{"jsonrpc":"2.0", "id": N, "method": "name", "params": {...}}`
- **Simulation** uses custom protocol: `{"cmd_id": N, "command": "name", "params": {...}}`
- **These are NOT compatible** — the backend currently does not communicate with the simulation.
- For development, the simulation is only used for the Python GUI visualization.
- In production, the backend will use real hardware via `fw/hw_interfaces.h`, not the simulation.

### 4.2 Verify Message Framing Consistency
- Backend: 4-byte big-endian length prefix + JSON body
- Simulation: 4-byte big-endian length prefix + JSON body
- Electron: 4-byte big-endian length prefix + JSON body
- ✅ Framing is consistent across all components.

---

## Phase 5: CI/CD Readiness

### 5.1 Checklist for CI Compatibility
- [ ] CMakeLists.txt uses `find_package` before `FetchContent` (offline-friendly)
- [ ] All FetchContent URLs are pinned to specific tags (not branches)
- [ ] `npm ci` can be used instead of `npm install` (if package-lock.json is committed)
- [ ] All tests run with `ctest --output-on-failure` return zero
- [ ] Build is reproducible: same commit → same binary
- [ ] No hardcoded absolute paths (except `/tmp` which is POSIX-standard)
- [ ] `.gitignore` excludes build artifacts, node_modules, IDE files

### 5.2 Recommended CI Pipeline (.gitlab-ci.yml example)
```yaml
stages:
  - deps
  - build
  - test

check-deps:
  stage: deps
  script:
    - bash .pi/scripts/check-deps.sh

build-backend:
  stage: build
  script:
    - cd 04_Implementation/src/backend
    - mkdir -p build && cd build
    - cmake .. -DBUILD_TESTS=ON
    - make -j$(nproc)

test-backend:
  stage: test
  script:
    - cd 04_Implementation/src/backend/build
    - ctest --output-on-failure
```

---

## Post-Verification: Update Dashboard

After successful verification, update `dashboard/data/status.json`:
- Set `04_implementation.checklist_done` to reflect build/test status
- Update `metrics.code_coverage_percent` if coverage was measured
- Update `metrics.test_cases_passed` with ctest results

Run:
```bash
make dashboard
```

---

## The Golden Rule

> **The project MUST build and start from a clean checkout without manual intervention.**

If any manual step is required (installing a specific package version, setting an environment variable, editing a config file), it must be:
1. Documented in this skill
2. Automated in `check-deps.sh` or `start.sh`
3. Added to the CI pipeline
