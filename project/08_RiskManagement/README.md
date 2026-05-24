# Risk Management — V-Model XT

## ⚠️ Risk Management is NOT a parallel track

Risk management FEEDS INTO requirements and architecture. It is not an isolated activity.

## Process Flow

```
User Needs (project/01_Requirements/00_UserNeeds/)
        │
        ▼
┌──────────────────────────────────────────────────┐
│ 01_RiskAnalysis/                                 │
│   HazardIdentification.md     ← PHA: what hazards│
│   RiskEstimation.md           ← Severity × Prob  │
│   RiskControls.md             ← Design/Protect/  │
│                                  Inform hierarchy│
│   RiskControls → Safety Reqs  ← THESE GO INTO   │
│                                  project/01_Reqs/│
│                                  02_SystemReqs/  │
└──────────────────────────────────────────────────┘
        │
        ▼
System Requirements (project/01_Requirements/02_SystemReqs/)
  ← includes safety requirements from risk controls
        │
        ▼
┌──────────────────────────────────────────────────┐
│ 02_FMEA/                                         │
│   SystemFMEA.md              ← Component-level   │
│   SoftwareFMEA.md            ← Software-specific │
│   ProcessFMEA.md             ← Manufacturing/    │
│                                  service risks   │
└──────────────────────────────────────────────────┘
        │
        ▼
┌──────────────────────────────────────────────────┐
│ 03_SafetyClassification/                         │
│   SoftwareSafetyClassification.md  ← IEC 62304 §4.3│
│   Assigns Class A/B/C to each SW item            │
└──────────────────────────────────────────────────┘
```

## Directory Purpose

| Directory | Content | When |
|-----------|---------|------|
| `01_RiskAnalysis/` | Hazard identification (PHA), risk estimation, risk controls | BEFORE system requirements baselining |
| `02_FMEA/` | Detailed FMEA for system, software, process | DURING architecture and design |
| `03_SafetyClassification/` | IEC 62304 software safety class assignment | AFTER risk analysis, BEFORE detailed design |

## Critical Rule (ISO 14971 + IEC 62304)

**Hazard analysis in `01_RiskAnalysis/` MUST be completed and reviewed BEFORE `project/01_Requirements/02_SystemReqs/` is baselined.**

Rationale: Risk controls identified in hazard analysis become safety requirements. These safety requirements are legally binding. Adding them after baselining constitutes a change request with full impact analysis.

## Cross-Reference

See `project/01_Requirements/README.md` for the complete User Needs → Risk → System Requirements flow.
