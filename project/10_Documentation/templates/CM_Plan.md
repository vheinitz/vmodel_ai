# Configuration Management Plan (CM Plan)

**Document ID:** {PROJECT_NUMBER}_CD_CM_v{MAJOR}.{MINOR}  
**Project:** {PROJECT_NAME}  
**Version:** v00.01 (Draft)  
**Date:** {DATE}  

---

## 1. Purpose
Define configuration management procedures for all {PROJECT_NAME} artifacts per IEC 62304 §8.

## 2. Configuration Items (CI)

| CI Category | Examples | Storage |
|-------------|---------|---------|
| Project Documents | PMP, QA Plan, SRS, SAD, SDD, FMEA | Git (Markdown) / File Server (Office) |
| Source Code | .cpp, .h, .qml, CMakeLists.txt | Git (GitLab) |
| Build Artifacts | Binaries, libraries | GitLab CI artifacts |
| Test Artifacts | Test cases, test results, reports | Git + CI |
| Release Packages | Installers, deployment packages | GitLab Releases |
| Development Tools | Compiler versions, Qt versions | Documented in CM Plan |

## 3. Version Control

### 3.1 Repository Structure
```
{PROJECT_NAME}/
├── src/           # Source code → Git branch: main
├── docs/          # Documentation → Git branch: main
├── tests/         # Test code → Git branch: main
├── releases/      # Release packages → Git tags
```

### 3.2 Branching Strategy
- `main` — Production-ready code (protected)
- `develop` — Integration branch
- `feature/{name}` — Feature development
- `bugfix/{ticket}` — Bug fixes
- `release/{version}` — Release preparation

### 3.3 Commit Convention
```
[TYPE] Component: Short description

[Detailed description if needed]
Refs: #TICKET
```
Types: `feat`, `fix`, `docs`, `test`, `refactor`, `ci`, `chore`

## 4. Baseline Management

### 4.1 Baselines
| Baseline | Content | Created At |
|----------|---------|------------|
| Requirements Baseline | All approved SRS/SyRS | G2 |
| Architecture Baseline | All approved SAD | G3 |
| Design Baseline | All approved SDD | G4 |
| Code Baseline | Tagged release version | G5 |
| Release Baseline | All release artifacts | G8 |

### 4.2 Baseline Procedure
1. All items reviewed and approved
2. Tag created in Git (e.g., `BASELINE-REQS-v1.0`)
3. Baseline record created in CM log
4. Change control applies after baseline

## 5. Change Control

### 5.1 Change Request (CR)
- CR ID assigned
- Change description
- Impact analysis (requirements, architecture, design, tests, risks)
- Approval by Change Control Board (CCB)
- Implementation and verification
- Documentation update

### 5.2 CCB Members
- Project Manager (Chair)
- Requirements Engineer
- Software Architect
- QA Manager
- Risk Manager (for safety-related changes)

## 6. Configuration Status Accounting

### 6.1 CM Log
| CI ID | Name | Version | Status | Baseline | Location |
|-------|------|---------|--------|----------|----------|
| CI-001 | SRS-AC | v01.00 | Approved | REQS-v1.0 | project/01_Requirements/... |

## 7. Tool Chain

| Tool | Version | Purpose |
|------|---------|---------|
| Git | ≥ 2.30 | Version control |
| GitLab | Latest | CI/CD, issue tracking |
| CMake | ≥ 3.16 | Build system |
| Qt | ≥ 5.12 | Application framework |
| GCC / MSVC | {VERSION} | Compiler |
| PostgreSQL | ≥ 9.6 | Database |

---

*Template version: 1.0 | IEC 62304 §8 compliant*
