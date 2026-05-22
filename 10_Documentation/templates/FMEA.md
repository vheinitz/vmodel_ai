# System FMEA (Failure Mode and Effects Analysis)

**Document ID:** {PROJECT_NUMBER}_CD_{COMPONENT}_FMEA_v{MAJOR}.{MINOR}  
**Project:** {PROJECT_NAME}  
**Standards:** ISO 14971:2019, IEC 62304:2006+AMD1:2015  
**Version:** v00.01 (Draft)  
**Date:** {DATE}  
**Author:** Risk Manager  

---

## 1. Introduction

### 1.1 Purpose
This FMEA identifies and analyzes potential failure modes of the {PROJECT_NAME} system, assesses their risks, and defines risk control measures per ISO 14971.

### 1.2 Scope
- System-level failure modes
- Software failure modes (IEC 62304)
- Hardware failure modes
- User error scenarios

### 1.3 Risk Acceptance Criteria
| Criterion | Threshold |
|-----------|-----------|
| Maximum RPN | < 50 (or ALARP justified) |
| Severity ≥ 8 | Must be mitigated regardless of RPN |
| Individual Risk | Must be as low as reasonably practicable (ALARP) |

## 2. Severity Scale

| Rating | Severity | Description | Example |
|--------|----------|-------------|---------|
| 10 | Catastrophic | Death | — |
| 9 | Critical | Permanent serious injury | Loss of limb |
| 8 | Critical | Serious injury needing intervention | Hospitalization |
| 7 | Major | Significant reversible injury | Professional medical attention |
| 6 | Major | Moderate reversible injury | Doctor visit |
| 5 | Minor | Minor injury | First aid |
| 4 | Minor | Slight injury | Discomfort |
| 3 | Negligible | No injury, inconvenience | Workflow disruption |
| 2 | Negligible | Minor annoyance | Cosmetic issue |
| 1 | None | No effect | — |

## 3. Occurrence Scale

| Rating | Occurrence | Description |
|--------|------------|-------------|
| 10 | Frequent | ≥ 1/day in normal use |
| 9 | Very High | Weekly |
| 8 | High | Monthly |
| 7 | Moderately High | Quarterly |
| 6 | Moderate | Annually |
| 5 | Low | Once in 2–5 years |
| 4 | Very Low | Once in 5–10 years |
| 3 | Remote | Once in 10+ years |
| 2 | Very Remote | Theoretically possible |
| 1 | Improbable | Effectively impossible |

## 4. Detection Scale

| Rating | Detection | Description |
|--------|-----------|-------------|
| 10 | Undetectable | No detection possible |
| 9 | Very Remote | Unlikely to detect |
| 8 | Remote | Low chance of detection |
| 7 | Very Low | May be detected |
| 6 | Low | Possibly detected |
| 5 | Moderate | Maybe detected |
| 4 | Moderately High | Good chance of detection |
| 3 | High | Very likely detected |
| 2 | Very High | Almost certainly detected |
| 1 | Certain | Always detected |

## 5. FMEA Table

| ID | Function | Failure Mode | Cause | Effect | S | O | D | RPN | Risk Control | Res. S | Res. O | Res. D | Res. RPN | Verification | REQ Link | Test Link | Status |
|----|----------|-------------|-------|--------|---|---|---|-----|-------------|--------|--------|--------|----------|-------------|----------|-----------|--------|
| FMEA-001 | Sample ID association | Wrong sample ID linked to result | Barcode read error | Wrong result reported to patient | 8 | 3 | 5 | 120 | Barcode verification with checksum + manual confirmation | 8 | 2 | 2 | 32 | Integration test with invalid barcodes | REQ-SW-AC-010 | TC-INT-005 | Open |
| FMEA-002 | Liquid handling | Wrong sample volume aspirated | Syringe calibration drift | Incorrect test result | 8 | 4 | 6 | 192 | Automated calibration check before each run | 8 | 2 | 2 | 32 | Calibration verification test | REQ-SW-AD-023 | TC-UNIT-023 | Open |
| FMEA-003 | Motor control | Uncontrolled arm movement | Firmware crash | Operator injury from moving parts | 7 | 2 | 4 | 56 | Hardware emergency stop + watchdog timer | 7 | 1 | 2 | 14 | Emergency stop test | REQ-HW-005 | TC-SYS-012 | Open |

## 6. Risk Control Verification

### 6.1 Verification Plan
| FMEA ID | Risk Control | Verification Method | Verifier | Date | Result |
|---------|-------------|-------------------|----------|------|--------|
| FMEA-001 | Barcode checksum | Integration test TC-INT-005 | Test Engineer | TBD | TBD |
| FMEA-002 | Auto-calibration | Unit test TC-UNIT-023 | Test Engineer | TBD | TBD |
| FMEA-003 | Emergency stop | System test TC-SYS-012 | Test Engineer | TBD | TBD |

### 6.2 Residual Risk Evaluation
| FMEA ID | Residual RPN | Acceptable? | Rationale |
|---------|-------------|-------------|-----------|
| FMEA-001 | 32 | Yes | ALARP — barcode verification reduces occurrence |
| FMEA-002 | 32 | Yes | ALARP — automated calibration ensures detection |
| FMEA-003 | 14 | Yes | Hardware safety measures provide adequate protection |

## 7. Risk-Benefit Analysis
*Complete for risks where residual risk remains above acceptance criteria.*

## 8. Document History

| Version | Date | Author | Changes |
|---------|------|--------|---------|
| v00.01 | {DATE} | {AUTHOR} | Initial FMEA |

---

*Template version: 1.0 | ISO 14971:2019 & IEC 62304 §7 compliant*
