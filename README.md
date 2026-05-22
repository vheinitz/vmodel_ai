# V-Model XT Project Template — Medical Lab Device Development

## Overview

This template implements the **V-Model XT** (German Federal Government Standard for IT systems development) adapted for **medical laboratory automation devices**. It provides a self-contained, version-controlled project structure that guides development from requirements through validation.

The template is **generic** — clone it, rename it to your project name, put it under Git, and you have a complete V-Model project skeleton.

- Complete directory structure for all V-Model phases  
- Document templates compliant with IEC 62304 / ISO 14971 / IVDR  
- Agent configurations for AI-assisted development in all V-Model roles  
- Automated progress dashboards and status tracking  
- Checklists for every development phase  
- Traceability links between requirements, architecture, design, implementation, and tests  

## V-Model XT Phases & Agent Flow

Agents work in a **reactive layer-listening pattern**: agents at each layer observe the layer above and produce/update artifacts in their own layer. Verification/validation agents listen on the same level's definition/implementation layers and produce test/validation artifacts.

```
                         ┌──────────────────────────────────────────────┐
  Project Definition     │                                              │
  & Planning             │  PM ── QA ── CM ── RM ── Regulatory         │
                         └──────────────────────────────────────────────┘

  Stakeholder Reqs ────────────────────────────────────── Validation (OQ/PQ)
        │                                                       ↑
  System Reqs ─────────────────────────────────── System Tests ↑
        │                                               ↑       │
  System Architecture ───────────────────── Architecture Tests  │
        │                                       ↑               │
  Software Reqs ─────────────────── Integration Tests          │
        │                               ↑                       │
  Software Architecture ─── Module Tests ↑                     │
        │                       ↑       │                       │
  Software Design ── Unit Tests  │       │                       │
        │               ↑       │       │                       │
  Implementation ───────┘       │       │                       │
                                └───────┴───────────────────────┘

  ───→ Definition flow (left side): upper layer changes trigger lower layer updates
  ←─── Verification flow (right side): same-level agents observe definition layer
```

### Agent Layer Dependencies

| Agent | Observes (triggered by changes in) | Produces/Updates |
|-------|-----------------------------------|-----------------|
| `requirements-engineer` | Stakeholder input, source code, docs | `01_Requirements/` — SRS, SyRS |
| `risk-manager` | Requirements, architecture changes | `08_RiskManagement/` — FMEA, risk analysis |
| `system-architect` | Requirements changes | `02_Architecture/01_SystemArchitecture/` |
| `software-architect` | System architecture, requirements changes | `02_Architecture/02_SoftwareArchitecture/` |
| `developer` | Software design changes | `04_Implementation/` — source code |
| `tester` (unit) | Software design, implementation | `06_Verification/01_UnitTests/` |
| `tester` (integration) | Software architecture, implementation | `06_Verification/02_IntegrationTests/` |
| `tester` (system) | System requirements, system architecture | `06_Verification/03_SystemTests/` |
| `tester` (architecture) | System architecture | `06_Verification/04_ArchitectureTests/` |
| `qa-manager` | All layers, checklists | QA reports, audits, gate decisions |

## Project Initialization & Workflow

### 1. Clone the Template
```bash
cp -r template/ your-project-name/
cd your-project-name
git init
git add -A
git commit -m "Initial project from V-Model XT template"
```

### 2. Initialize with Project Data
```bash
bash .pi/scripts/init-project.sh
```
You are prompted for project number, name, description, and IEC 62304 safety class (A/B/C).

### 3. Populate Input Data
Place any existing artifacts (requirements docs, source code, architecture diagrams) in a temporary input directory or directly in the project folders. Agents will process these when triggered.

### 4. Trigger the Agent Pipeline
```bash
make all
```
This runs: dashboard update → all agents → checklists → traceability generation.

Each agent:
1. Reads the project state from `dashboard/data/status.json`
2. Scans its observed directories for changes
3. Produces/updates documents in its output directories
4. Updates the dashboard with findings and suggestions

### 5. View Dashboard
Open `dashboard/index.html` to see the V-Model visualization, phase progress, agent status, and suggestions.

## Directory Structure

| Directory | Content |
|-----------|---------|
| `00_ProjectManagement/` | Project plans, PMP, QA plan, CM plan |
| `01_Requirements/` | Stakeholder, System, Software, Hardware requirements |
| `02_Architecture/` | System Architecture (SyAD), SW Architecture (SW-SAD), HW Architecture |
| `03_Design/` | System Design (SDD), SW Design, HW Design |
| `04_Implementation/` | Source code, unit test code |
| `05_Integration/` | Software integration, system integration plans & reports |
| `06_Verification/` | Unit tests, integration tests, system tests, architecture tests |
| `07_Validation/` | Operational Qualification (OQ), Performance Qualification (PQ) |
| `08_RiskManagement/` | Risk analysis, FMEA, safety classification (IEC 62304) |
| `09_Regulatory/` | IEC 62304, ISO 14971, IVDR compliance documentation |
| `10_Documentation/` | Document templates, glossaries, generated documents, document index |
| `99_Archive/` | Archived versions, superseded documents |

### Subdirectory Conventions

- `_RAW/` — Source/editable files (PPTX, DOCX, XLSX, VSDX, etc.)
- `_Archiv/` — Superseded versions
- `_Trash/` — Discarded, not needed but preserved

## Document Numbering Convention

```
[ProjectNumber]_[Component]_[DocumentType]_v[Major].[Minor].ext
```

| Placeholder | Meaning |
|-------------|---------|
| `[ProjectNumber]` | Your project number |
| `[Component]` | System-level (`SYS`) or component code (e.g., `GUI`, `CTRL`, `FW`) |
| `[DocumentType]` | `PMP`, `SRS`, `SyRS`, `SAD`, `SDD`, `FMEA`, `RMP`, etc. |
| `v[Major].[Minor]` | Version (v00.01 draft, v01.00 approved) |

## Regulatory Framework (Medical Device Software)

- **IEC 62304:2006+AMD1:2015** — Medical device software lifecycle  
- **ISO 14971:2019** — Risk management for medical devices  
- **ISO 13485:2016** — Quality management systems  
- **IVDR (EU) 2017/746** — In-vitro diagnostic medical devices regulation  

## AI Agent Roles

| Agent Role | Responsibility |
|------------|---------------|
| `project-manager` | Project planning, milestones, resource allocation |
| `requirements-engineer` | Elicitation, analysis, specification, traceability |
| `system-architect` | System architecture, interface specifications |
| `software-architect` | Software architecture, component design |
| `developer` | Implementation, code reviews, unit tests |
| `tester` | Test planning, test execution, verification reports |
| `risk-manager` | Risk analysis, FMEA, safety classification |
| `qa-manager` | Quality assurance, process audits, compliance checks |

## Scripts

| Script | Purpose |
|--------|---------|
| `init-project.sh` | Initialize project from template (interactive) |
| `trigger-agents.sh` | Run all agents to analyze state and propose next steps |
| `update-dashboard.sh` | Scan project and update dashboard data |
| `run-checklists.sh` | Execute phase checklists and generate status |
| `generate-traceability.sh` | Generate traceability matrix |

## Makefile Commands

| Command | Effect |
|---------|--------|
| `make init` | Initialize a new project |
| `make status` | Show current project status |
| `make dashboard` | Update dashboard data from project state |
| `make agents` | Trigger all AI agents for analysis |
| `make checklists` | Run checklists for the current phase |
| `make traceability` | Generate traceability matrix |
| `make all` | Full cycle: dashboard + agents + checklists + traceability |
| `make count` | Count all project artifacts |
