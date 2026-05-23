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
  (in src/)                     └───────┴───────────────────────┘

  ───→ Definition flow (left side): upper layer changes trigger lower layer updates
  ←─── Verification flow (right side): same-level agents observe definition layer
  Unit tests live alongside code in src/<component>/tests/
  Integration, system, architecture tests live in project/06_Verification/
```

### Agent Layer Dependencies

| Agent | Observes (triggered by changes in) | Produces/Updates |
|-------|-----------------------------------|-----------------|
| `requirements-engineer` | Stakeholder input, source code, docs | `project/01_Requirements/` — SRS, SyRS |
| `risk-manager` | Requirements, architecture changes | `project/08_RiskManagement/` — FMEA, risk analysis |
| `system-architect` | Requirements changes | `project/02_Architecture/01_SystemArchitecture/` |
| `software-architect` | System architecture, requirements changes | `project/02_Architecture/02_SoftwareArchitecture/` |
| `developer` | Software design changes | `src/` — source code + unit tests |
| `tester` (unit) | Software design, implementation | `src/<component>/tests/` — unit tests |
| `tester` (integration) | Software architecture, implementation | `project/06_Verification/02_IntegrationTests/` |
| `tester` (system) | System requirements, system architecture | `project/06_Verification/03_SystemTests/` |
| `tester` (architecture) | System architecture | `project/06_Verification/04_ArchitectureTests/` |
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

### 2. Load the Bootstrap Context into Your AI Agent
**Read `PI_CONTEXT.md` into your pi/coding-agent instance first.** This file gives the agent complete knowledge of:
- The V-Model XT system and all 10 agents
- Every directory and its purpose
- The reactive layer-listening agent workflow
- Quick-start prompts for common tasks

Then use one of the quick-start prompts from `PI_CONTEXT.md` to begin your session.

### 3. Initialize with Project Data
```bash
bash .pi/scripts/init-project.sh
```
You are prompted for project number, name, description, and IEC 62304 safety class (A/B/C).
Alternatively, let the AI agent guide you through initialization interactively.

### 4. Add Existing Artifacts
Place any existing artifacts (requirements docs, source code, architecture diagrams) in a temporary directory or directly in the project folders. Agents will process these when you ask them to.

## Directory Structure

| Directory | Content |
|-----------|---------|
| `src/` | All source code (MainTool, DataAnalyser, ConfigEditor, Firmware) + unit tests |
| `project/00_ProjectManagement/` | Project plans, PMP, QA plan, CM plan |
| `project/01_Requirements/` | Stakeholder, System, Software, Hardware requirements |
| `project/02_Architecture/` | System Architecture (SyAD), SW Architecture (SW-SAD), HW Architecture |
| `project/03_Design/` | System Design (SDD), SW Design, HW Design |
| `project/04_Implementation/` | Implementation-related project docs (build env, coding standards) |
| `project/05_Integration/` | Software integration, system integration plans & reports |
| `project/06_Verification/` | Integration tests, system tests, architecture tests |
| `project/07_Validation/` | Operational Qualification (OQ), Performance Qualification (PQ) |
| `project/08_RiskManagement/` | Risk analysis, FMEA, safety classification (IEC 62304) |
| `project/09_Regulatory/` | IEC 62304, ISO 14971, IVDR compliance documentation |
| `project/10_Documentation/` | Document templates, glossaries, generated documents, document index |
| `project/99_Archive/` | Archived versions, superseded documents |

> **Code lives in `src/`**, organized by standalone component (MainTool, DataAnalyser, ConfigEditor, Firmware).
> Each component has its own `tests/` subdirectory for unit tests.
> All project management artifacts live under `project/`. Integration/system/architecture tests are in `project/06_Verification/`.

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
| `developer` | Implementation in `src/`, code reviews, unit tests in `src/<comp>/tests/` |
| `tester` | Integration/system/architecture test planning & execution in `project/06_Verification/` |
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
