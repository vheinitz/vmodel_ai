# Requirements Flow — V-Model XT

## ⚠️ Critical Process Order

The V-Model requires this sequence. Do NOT skip or reorder:

```
┌─────────────────────────────────────────────────────────────┐
│ 1. USER NEEDS (Lastenheft)                                  │
│    00_UserNeeds_Lastenheft/                                 │
│    WHAT the users and stakeholders need                     │
│    Written in user language, not technical specs            │
│    Source: stakeholder interviews, existing product docs    │
└────────────────────────────┬────────────────────────────────┘
                             │
                             ▼
┌─────────────────────────────────────────────────────────────┐
│ 2. RISK ANALYSIS ← MUST happen BEFORE system requirements   │
│    00_RiskInputs/ → links to ../../08_RiskManagement/       │
│    Identify hazards from user needs                         │
│    Risk controls become safety requirements                 │
│    FMEA entries created per user need                       │
└────────────────────────────┬────────────────────────────────┘
                             │
                             ▼
┌─────────────────────────────────────────────────────────────┐
│ 3. SYSTEM REQUIREMENTS (Pflichtenheft)                      │
│    02_SystemReqs/                                           │
│    WHAT the system must do to fulfill user needs            │
│    INCLUDES safety requirements derived from risk analysis  │
│    Binding, testable, verifiable                            │
└────────────────────────────┬────────────────────────────────┘
                             │
                             ▼
┌─────────────────────────────────────────────────────────────┐
│ 4. SOFTWARE REQUIREMENTS                                    │
│    03_SoftwareReqs/                                         │
│    Software-specific requirements derived from system reqs  │
│    Each SW requirement traces to ≥1 system requirement      │
└────────────────────────────┬────────────────────────────────┘
                             │
                             ▼
┌─────────────────────────────────────────────────────────────┐
│ 5. HARDWARE REQUIREMENTS                                    │
│    04_HardwareReqs/                                         │
│    Hardware-specific requirements                           │
└─────────────────────────────────────────────────────────────┘
```

## Directory Purpose

| Directory | German Name | Content | Input From | Output To |
|-----------|------------|---------|------------|-----------|
| `00_UserNeeds_Lastenheft/` | Lastenheft | Stakeholder wishes, user stories, intended use | Stakeholders, existing products | Risk Analysis, System Reqs |
| `00_RiskInputs/` | Risikoanalyse-Vorgaben | Link to risk analysis — hazard identification from user needs | 00_UserNeeds, 08_RiskManagement | 02_SystemReqs |
| `02_SystemReqs/` | Pflichtenheft | Binding system requirements including safety reqs | User Needs + Risk Analysis | SW Reqs, HW Reqs, Architecture |
| `03_SoftwareReqs/` | Software-Anforderungen | Software-specific requirements | System Reqs | SW Architecture |
| `04_HardwareReqs/` | Hardware-Anforderungen | Hardware-specific requirements | System Reqs | HW Architecture |

## Key Rule

**System Requirements (Pflichtenheft) MUST NOT be baselined before:**
1. User Needs (Lastenheft) are documented ✅
2. Risk Analysis (hazard identification) is complete ✅
3. Risk controls have been formulated as safety requirements ✅

This ensures safety requirements are an integral part of the system requirements, not an afterthought. This is mandatory per ISO 14971 and IEC 62304.
