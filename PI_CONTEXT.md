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
│   ├── rules/           ← 6 rules (workflow, naming, compliance, extraction, risk-doc-structure, coding-standards)
│   ├── skills/          ← 11 skills (checklists, risk analysis, traceability, architecture, medical UI design, etc.)
│   └── scripts/         ← 5 automation scripts
├── src/                   ← All source code (separated from project management)
├── project/               ← All V-Model project management & documentation
│   ├── 00_ProjectManagement/  ← PMP, QA Plan, CM Plan, Project Manual
│   ├── 01_Requirements/       ← Stakeholder → System → Software → HW reqs
│   │   ├── 00_UserNeeds_Lastenheft/  ← WHAT users need (Lastenheft)
│   │   ├── 00_RiskInputs/            ← Links to 08_RiskManagement (hazard analysis)
│   │   ├── 02_SystemReqs/            ← Binding system reqs (Pflichtenheft) incl. safety
│   │   ├── 03_SoftwareReqs/          ← Software-specific requirements
│   │   ├── 04_HardwareReqs/          ← Hardware-specific requirements
│   │   └── README.md                 ← Lastenheft → Risk → Pflichtenheft flow
│   ├── 02_Architecture/       ← System Arch → SW Arch → HW Arch
│   ├── 03_Design/             ← System Design → SW Design → HW Design
│   ├── 04_Implementation/     ← Implementation-related project docs (build env, coding standards)
│   ├── 05_Integration/        ← SW Integration + System Integration plans
│   ├── 06_Verification/       ← Integration Tests → System Tests → Architecture Tests
│   ├── 07_Validation/         ← IQ → OQ → PQ
│   │   ├── 00_InstallationQualification/  ← IQ: installed correctly?
│   │   ├── 01_OperationalQualification/   ← OQ: works in target environment?
│   │   ├── 02_PerformanceQualification/   ← PQ: performs to user needs?
│   │   └── README.md
│   ├── 08_RiskManagement/     ← Risk Analysis, FMEA, Safety Classification
│   ├── 09_Regulatory/         ← IEC 62304, ISO 14971, IVDR compliance matrices
│   ├── 10_Documentation/      ← Templates (PMP, SRS, SAD, SDD, FMEA, TestPlan, ...)
│   └── 99_Archive/            ← Superseded versions
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
| 2 | `requirements-engineer` | Stakeholder input, code, docs | `project/01_Requirements/` — SRS, SyRS, initial risk analysis |
| 3 | `risk-manager` | Requirements, architecture | `project/08_RiskManagement/` — FMEA, risk controls |
| 4 | `system-architect` | Requirements changes | `project/02_Architecture/01_SystemArchitecture/` |
| 5 | `software-architect` | System arch + SW reqs | `project/02_Architecture/02_SoftwareArchitecture/` |
| 6 | `developer` | Software design docs | `src/` — all implementation code + unit tests |
| 7 | `tester` | Design + implementation | `project/06_Verification/` — integration, system, architecture tests |
| 8 | `qa-manager` | All layers, checklists | QA reports, gate decisions, audits |
| 9 | `innovation-manager` | Project state (on demand) | Innovation review, tech refresh recommendations |
| 10 | `medical-domain-expert` | Clinical requirements (on demand) | Clinical validation, IVDR guidance |

**Layer flow:**
```
Stakeholder Input
    ↓ requirements-engineer observes → writes project/01_Requirements/
    ↓ risk-manager observes requirements → writes project/08_RiskManagement/
    ↓ system-architect observes requirements → writes project/02_Architecture/01_System/
    ↓ software-architect observes sys-arch + SW-reqs → writes project/02_Architecture/02_SW/
    ↓ developer observes design → writes src/
    ↓ tester observes design + impl → writes project/06_Verification/
    ↓ qa-manager observes all → gate decisions
```

## Key Commands

```bash
make init           # Initialize project (prompts for name, number, class, components)
make dashboard      # Scan project and update dashboard data
make agents         # Trigger all active agents to analyze and produce
make checklists     # Evaluate phase checklists
make traceability   # Generate requirements-to-tests traceability matrix
make all            # Full cycle: dashboard + agents + checklists + traceability
make innovate       # Trigger innovation review (on demand)
make medical-review # Trigger clinical domain review (on demand)

# Automation (template-driven, deterministic — no LLM call required)
make validate       # Validate artifact frontmatter under project/ (writes validation.json)
make gates          # Evaluate decision-gate readiness (patches status.json + writes gates.json)
make validate-example # Validate the seed example (examples/coag-analyzer/)
make gates-example  # Evaluate gates on the seed example (G2 should be READY)
make bootstrap-test # Sandbox smoke-test that the template still bootstraps cleanly
```

## Artifact Format — Frontmatter Contract (mandatory)

Every artifact you create lives in **its own file** with YAML frontmatter on top.
The frontmatter is what makes the pipeline automatic: validators, the gate-readiness
engine and the traceability builder all read these fields.

- **Schema:** see `.pi/rules/artifact-frontmatter.md` for the per-type required keys,
  closed vocabulary and ID patterns.
- **Filename = `<id>.md`** (e.g. `REQ-SW-AC-001.md`, `FMEA-001.md`, `TC-INT-005.md`).
- **One artifact per file.** Compiled views like a full SRS document are *generated*
  from the per-file artifacts; do not edit them directly.
- **Format reference:** `examples/coag-analyzer/` is a small, complete, validated
  worked example — read it once before creating your first artifact in a new project.
- **Per-type starter templates:** `project/10_Documentation/templates/REQ.md`,
  `STK.md`, `SysREQ.md` (plus the existing FMEA/TC/SDD/SRS cover-doc templates).
- **Before you commit:** run `make validate`. If it returns errors, fix them.

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
- **Read relevant skills** in `.pi/skills/` for detailed methodology:
  - `.pi/skills/medical-ui-design.md` — MANDATORY for any UI/UX design, technology selection, or accessibility work
  - `.pi/skills/architecture-patterns.md` — system/software architecture patterns
  - `.pi/skills/requirements-quality-checklist.md` — pre-baseline requirements review
  - `.pi/skills/req-to-risk-derivation.md` — deriving FMEA from requirements
- **Write code to `src/<component>/`**, project artifacts to `project/` — never to temporary locations
- **Write unit tests alongside code** in `src/<component>/tests/` — integration/system/architecture tests go to `project/06_Verification/`
- **Every artifact carries frontmatter** per `.pi/rules/artifact-frontmatter.md`. One artifact per file, filename = `<id>.md`.
- **Run `make validate` before declaring work done.** Validator failures are bugs in your artifact, not the system.
- **Update `dashboard/data/status.json`** after each significant action (use `make gates` to refresh the gate flags deterministically)
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
Start populating project/01_Requirements/ and proposing initial FMEA entries.
```

### Prompt 3: Full agent pipeline on existing project
```
Read PI_CONTEXT.md. I have an existing project with code at [path] and 
documentation at [docs-path]. Run through the full V-Model:
1. Extract requirements from docs+code → project/01_Requirements/
2. Derive risks → project/08_RiskManagement/
3. Propose system architecture → project/02_Architecture/
4. Design software architecture → project/02_Architecture/
5. Plan verification tests → project/06_Verification/
6. Implement code → src/
Update the dashboard after each step.
```
