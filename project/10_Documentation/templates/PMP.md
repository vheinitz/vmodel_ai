# Project Management Plan (PMP)

**Document ID:** {PROJECT_NUMBER}_CD_PMP_v{MAJOR}.{MINOR}  
**Project:** {PROJECT_NAME}  
**Safety Class:** {SAFETY_CLASS} (IEC 62304)  
**Version:** v00.01 (Draft)  
**Date:** {DATE}  
**Author:** Project Manager  
**Reviewer:** QA Manager  
**Approver:** Senior Management  

---

## 1. Project Overview

### 1.1 Purpose
This Project Management Plan (PMP) defines the management approach for the development of **{PROJECT_NAME}**, a medical laboratory automation device developed by your organization.

### 1.2 Scope
The project encompasses:
- Software development for the GUI application component
- Software development for the device control component
- Firmware development for embedded controller boards
- System integration and verification
- Regulatory compliance (IEC 62304, ISO 14971, ISO 13485, IVDR)

### 1.3 Development Model
This project follows **V-Model XT** (German Federal IT Standard) adapted for medical device software development.

## 2. Project Organization

### 2.1 Roles and Responsibilities

| Role | Person | Responsibility |
|------|--------|---------------|
| Project Manager | {PM_NAME} | Overall project management, reporting |
| Requirements Engineer | {RE_NAME} | Requirements elicitation and management |
| System Architect | {SA_NAME} | System architecture definition |
| Software Architect | {SWA_NAME} | Software architecture and design |
| Lead Developer | {DEV_NAME} | Implementation leadership |
| Test Manager | {TST_NAME} | Test planning and execution |
| Risk Manager | {RM_NAME} | Risk analysis and FMEA |
| QA Manager | {QA_NAME} | Quality assurance and audits |
| Regulatory Lead | {REG_NAME} | Regulatory submissions and compliance |

### 2.2 Organizational Chart
```
                    ┌─────────────────────┐
                    │   Senior Management  │
                    └──────────┬──────────┘
                               │
                    ┌──────────▼──────────┐
                    │   Project Manager    │
                    └──────────┬──────────┘
                               │
          ┌────────────────────┼────────────────────┐
          │                    │                    │
    ┌─────▼─────┐      ┌──────▼──────┐      ┌─────▼─────┐
    │ Development│      │ Architecture│      │   QA/RM   │
    │   Team     │      │    Team     │      │    Team   │
    └───────────┘      └─────────────┘      └───────────┘
```

## 3. Project Phases and Milestones

### 3.1 Phase Plan

| Phase | Start | End | Milestone |
|-------|-------|-----|-----------|
| Project Initiation | {DATE} | {DATE+14} | G1: Project Approved |
| Requirements Analysis | {DATE+14} | {DATE+44} | G2: Reqs Baselined |
| System & SW Architecture | {DATE+30} | {DATE+74} | G3: Architecture Defined |
| Detailed Design | {DATE+60} | {DATE+104} | G4: Design Completed |
| Implementation | {DATE+90} | {DATE+164} | G5: Implementation Done |
| Integration | {DATE+150} | {DATE+194} | G6: Integration Done |
| Verification (Testing) | {DATE+180} | {DATE+224} | G7: Verification Done |
| Validation (OQ/PQ) | {DATE+210} | {DATE+254} | G8: Validation Done |
| Release | {DATE+240} | {DATE+268} | G9: Project Completed |

### 3.2 Decision Gates (Entscheidungspunkte)

| Gate | Criteria | Review Body |
|------|----------|------------|
| **G1** | PMP approved, resources allocated, toolchain set up | Steering Committee |
| **G2** | All requirements baselined, traceability established | Requirements Review Board |
| **G3** | Architecture documented, reviewed, baselined | Architecture Review Board |
| **G4** | Detailed design completed, reviewed, baselined | Design Review Board |
| **G5** | All code implemented, unit-tested, reviewed | Technical Review |
| **G6** | Integration tests passed, defect resolution complete | Integration Review |
| **G7** | All verification tests passed, traceability complete | Verification Review |
| **G8** | OQ/PQ passed, risk management file closed | Validation Review |
| **G9** | Final acceptance, all deliverables complete | Project Closure |

## 4. Resource Plan

### 4.1 Personnel

| Role | FTE | Duration |
|------|-----|----------|
| Project Manager | 0.5 | Full project |
| Requirements Engineer | 1.0 | Phases 1–2 |
| System Architect | 1.0 | Phases 1–3 |
| Software Architect | 1.0 | Phases 2–5 |
| Developers | 2–4 | Phases 4–6 |
| Testers | 1–2 | Phases 5–7 |
| Risk Manager | 0.5 | Full project |
| QA Manager | 0.5 | Full project |

### 4.2 Infrastructure
- GitLab: Version control and CI/CD
- CMake: Build system
- PostgreSQL: Database
- {FRAMEWORK}: Application framework
- Test environment: Hardware-in-the-loop test rig

## 5. Communication Plan

| Meeting | Frequency | Participants | Purpose |
|---------|-----------|-------------|---------|
| Daily Standup | Daily | Dev team | Progress and blockers |
| Sprint Planning | Bi-weekly | Dev team, PM | Sprint backlog |
| Sprint Review | Bi-weekly | All stakeholders | Demo and feedback |
| Phase Review | Per phase | Review board | Gate decision |
| Steering Committee | Monthly | Management | Strategic direction |
| Risk Review | Monthly | Risk Manager, PM | Risk status |

## 6. Risk Management

Risk management is conducted per ISO 14971:2019 and documented in:
- `project/08_RiskManagement/01_RiskAnalysis/RiskManagementPlan.md`
- `project/08_RiskManagement/02_FMEA/SystemFMEA.md`

## 7. Quality Assurance

Quality assurance is conducted per ISO 13485:2016 and documented in:
- `project/00_ProjectManagement/03_QualityAssurance/QA_Plan.md`

## 8. Configuration Management

Configuration management is documented in:
- `project/00_ProjectManagement/04_ConfigurationManagement/CM_Plan.md`

---

*Template version: 1.0*
