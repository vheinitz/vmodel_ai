# PI_CONTEXT.md — V-Model XT Project Bootstrap

> **Load this file into a fresh pi instance** after cloning the template.
> It gives the agent complete understanding of the project system, all agents,
> the V-Model workflow, and what you expect it to do.

---

## What This Project Is

This is a **V-Model XT development project** for a **medical laboratory automation device** (in-vitro diagnostic / IVD instrument). The project follows:

- **V-Model XT** — German federal standard for system development
- **IEC 62304** — Medical device software lifecycle (safety class to be set at init)
- **ISO 14971** — Risk management for medical devices
- **ISO 13485** — Quality management for medical devices
- **IVDR (EU) 2017/746** — In-vitro diagnostic regulation

## Project Structure (What Every Directory Is For)

```
.
├── .pi/
│   ├── agents/          ← 10 AI agents, each with defined role + listening pattern
│   ├── rules/           ← 4 rules (workflow, naming, compliance, risk-doc-structure)
│   ├── skills/          ← 8 skills (checklists, risk analysis, traceability, architecture, etc.)
│   └── scripts/         ← 5 automation scripts
├── 00_ProjectManagement/  ← PMP, QA Plan, CM Plan, Project Manual
├── 01_Requirements/       ← Stakeholder → System → Software → Hardware reqs
├── 02_Architecture/       ← System Arch → SW Arch → HW Arch
├── 03_Design/             ← System Design → SW Design → HW Design
├── 04_Implementation/     ← src/ (code), 01_UnitTests/
├── 05_Integration/        ← SW Integration + System Integration plans
├── 06_Verification/       ← Unit Tests → Integration Tests → System Tests → Architecture Tests
├── 07_Validation/         ← OQ (Operational Qualification) + PQ (Performance Qualification)
├── 08_RiskManagement/     ← Risk Analysis, FMEA, Safety Classification
├── 09_Regulatory/         ← IEC 62304, ISO 14971, IVDR compliance matrices
├── 10_Documentation/      ← Templates (PMP, SRS, SAD, SDD, FMEA, TestPlan, ...)
├── 99_Archive/            ← Superseded versions
├── dashboard/
│   ├── index.html         ← Self-contained project dashboard
│   └── data/
│       ├── project.json   ← Project metadata (number, name, class, components)
│       └── status.json    ← Live project status (all agents write here)
└── Makefile               ← Central command hub
```

## The Agent System — How It Works

The project has **10 AI agents**, each with a specific V-Model role. They work in a **reactive layer-listening pattern**:

| # | Agent | Observes (triggered by changes in) | Produces/Writes |
|---|-------|-----------------------------------|-----------------|
| 1 | `project-manager` | All layers (overall progress) | PMP, project plan, coordination |
| 2 | `requirements-engineer` | Stakeholder input, code, docs | `01_Requirements/` — SRS, SyRS, initial risk analysis |
| 3 | `risk-manager` | Requirements, architecture | `08_RiskManagement/` — FMEA, risk controls |
| 4 | `system-architect` | Requirements changes | `02_Architecture/01_SystemArchitecture/` |
| 5 | `software-architect` | System arch + SW reqs | `02_Architecture/02_SoftwareArchitecture/` |
| 6 | `developer` | Software design docs | `04_Implementation/src/` + unit tests |
| 7 | `tester` | Design + implementation | `06_Verification/` — all test levels |
| 8 | `qa-manager` | All layers, checklists | QA reports, gate decisions, audits |
| 9 | `innovation-manager` | Project state (on demand) | Innovation review, tech refresh recommendations |
| 10 | `medical-domain-expert` | Clinical requirements (on demand) | Clinical validation, IVDR guidance |

**Layer flow:**
```
Stakeholder Input
    ↓ requirements-engineer observes → writes 01_Requirements/
    ↓ risk-manager observes requirements → writes 08_RiskManagement/
    ↓ system-architect observes requirements → writes 02_Architecture/01_System/
    ↓ software-architect observes sys-arch + SW-reqs → writes 02_Architecture/02_SW/
    ↓ developer observes design → writes 04_Implementation/
    ↓ tester observes design + impl → writes 06_Verification/
    ↓ qa-manager observes all → gate decisions
```

## Key Commands

```bash
make init          # Initialize project (prompts for name, number, class, components)
make dashboard     # Scan project and update dashboard data
make agents        # Trigger all active agents to analyze and produce
make checklists    # Evaluate phase checklists
make traceability  # Generate requirements-to-tests traceability matrix
make all           # Full cycle: dashboard + agents + checklists + traceability
make innovate      # Trigger innovation review (on demand)
make medical-review # Trigger clinical domain review (on demand)
```

## What You (the User) Want Me (the Agent) To Do

### Primary Use Case: Porting an Existing Product

You have an **existing medical lab device** with:
- Existing source code (C++, Qt, embedded C, ...)
- Existing documentation (SRS, architecture docs, FMEA, test docs in `input/` or elsewhere)
- The product needs to be **rewritten or substantially re-architected**

You want me to:
1. **Extract requirements** from existing code and documentation
2. **Complete risk management** (FMEA) based on requirements
3. **Propose system architecture** for the rewrite
4. **Design software architecture** with component decomposition
5. **Implement software modules** with unit/module/system tests
6. **Validate** everything against regulatory standards

### How I Should Work

- Use the **agent system**: for each task, I role-play the appropriate agent
- **Read the agent's config** in `.pi/agents/<agent>.md` — it tells me exactly what to observe and produce
- **Read relevant skills** in `.pi/skills/` for detailed methodology
- **Write to the project directories**, not to temporary locations
- **Update `dashboard/data/status.json`** after each significant action
- **Follow the V-Model phase sequence**: don't jump to implementation before requirements are baselined

## Current Project State

When I start, I should:
1. Read `dashboard/data/status.json` to know what phase we're in
2. Check which agents have already run and what they produced
3. Identify the next logical step in the V-Model flow
4. Proceed with that step, updating the dashboard as I go

If `status.json` shows everything is `pending` (fresh clone), I should:
1. Help initialize the project (`make init` equivalent — set project name, class, components)
2. Begin with **Phase 0 (Initiation)** and **Phase 1 (Requirements)**
3. Extract requirements from any existing code/docs the user provides

---

## Quick-Start Prompts for the User

### Prompt 1: Initialize a fresh project
```
I've cloned the V-Model XT template. Read PI_CONTEXT.md first to understand 
the system. Then help me initialize this project. Ask me for the project name,
number, IEC 62304 safety class (A/B/C), and component codes.
```

### Prompt 2: Import requirements from existing code
```
Read PI_CONTEXT.md. I have an existing medical lab device codebase at 
[path/to/code]. Analyze it and extract:
- Implicit requirements from the source code
- System architecture from the code structure
- Identify what's safety-critical vs non-critical
Start populating 01_Requirements/ and proposing initial FMEA entries.
```

### Prompt 3: Full agent pipeline on existing project
```
Read PI_CONTEXT.md. I have an existing project with code at [path] and 
documentation at [docs-path]. Run through the full V-Model:
1. Extract requirements from docs+code → 01_Requirements/
2. Derive risks → 08_RiskManagement/
3. Propose system architecture → 02_Architecture/
4. Design software architecture → 02_Architecture/
5. Plan verification tests → 06_Verification/
Update the dashboard after each step.
```
