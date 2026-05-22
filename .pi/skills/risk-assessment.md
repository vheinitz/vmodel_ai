# Skill: Risk Assessment

## Purpose
Guide the systematic identification, analysis, and control of risks for medical device software per ISO 14971 and IEC 62304.

## Usage
When invoked, this skill:
1. Scans the project for hazards based on requirements and architecture
2. Generates or updates the FMEA
3. Checks risk control measures are verified
4. Reports risk metrics to the dashboard

## Hazard Categories for Medical Lab Devices

### Biological Hazards
- Biohazard exposure (sample spill, aerosol)
- Cross-contamination between samples
- Reagent contamination
- Infection risk from sharps

### Electrical Hazards
- Electric shock from power supply
- Short circuit causing fire
- EMI affecting other medical devices

### Mechanical Hazards
- Moving parts (robotic arm, conveyor) — pinch/crush
- Sharp edges on chassis
- Falling objects (heavy components)

### Software/Data Hazards
- Wrong patient result displayed
- Wrong sample identification
- Wrong reagent identification
- Wrong protocol execution
- Data corruption/loss
- Unauthorized access to patient data
- Network communication failure
- Incorrect calibration data
- Software crash during operation

### Use Error Hazards
- Wrong reagent loaded
- Wrong sample tube placed
- Wrong test protocol selected
- Maintenance procedure error
- Configuration error

## FMEA Severity Scale (ISO 14971)

| Severity | Rating | Description |
|----------|--------|-------------|
| Catastrophic | 10 | Death or permanent serious injury |
| Critical | 9-8 | Serious injury requiring medical intervention |
| Major | 7-6 | Reversible injury, professional medical attention |
| Minor | 5-4 | Minor injury, no professional attention needed |
| Negligible | 3-1 | No injury, inconvenience only |

## FMEA Occurrence Scale

| Occurrence | Rating | Description |
|------------|--------|-------------|
| Frequent | 10-9 | Occurs daily in normal use |
| Probable | 8-7 | Occurs weekly to monthly |
| Occasional | 6-5 | Occurs a few times per year |
| Remote | 4-3 | Occurs once in several years |
| Improbable | 2-1 | Theoretically possible but unlikely |

## FMEA Detection Scale

| Detection | Rating | Description |
|-----------|--------|-------------|
| Undetectable | 10 | No way to detect failure before harm |
| Very Low | 9-8 | Remote chance of detection |
| Low | 7-6 | May be detected by experienced user |
| Moderate | 5-4 | Likely detected before harm |
| High | 3-2 | Almost certainly detected |
| Certain | 1 | Always detected before harm |

## Risk Control Hierarchy (ISO 14971)
1. **Inherent safety by design** — Design out the hazard
2. **Protective measures** — Alarms, interlocks, guards
3. **Information for safety** — Labels, warnings, training, PPE

## Risk Acceptance Criteria
- **RPN > 100**: Must be mitigated — redesign required
- **RPN 50–100**: ALARP (As Low As Reasonably Practicable) — mitigate if feasible
- **RPN < 50**: Acceptable — document rationale
- **Severity ≥ 8**: Must be mitigated regardless of RPN

## Verification of Risk Controls
Each risk control measure must have:
- Verification method (test, inspection, analysis)
- Linked requirement ID
- Linked test case ID
- Verification result
- Pass/fail status
