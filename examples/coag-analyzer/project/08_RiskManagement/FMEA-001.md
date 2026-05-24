---
id: FMEA-001
type: fmea-entry
status: controlled
hazard: Optical-sensor saturation produces silently incorrect PT result
hazardous_situation: A saturated optical reading is interpreted by the curve-fit as a fast clot, returning a falsely short PT.
harm: Clinician under-doses anticoagulant based on the false PT; patient suffers thrombotic event.
severity: 9
probability: 3
detection: 5
rpn: 135
controls: [REQ-SW-AC-003, REQ-SW-AC-005]
residual_severity: 9
residual_probability: 1
residual_acceptable: true
related_requirements: [REQ-SYS-005]
tests: [TC-INT-001, TC-INT-002]
created: 2026-05-24
updated: 2026-05-24
approver: Risk Manager
---

# FMEA-001: Optical-sensor saturation → false PT

## Hazard Description

Strong ambient or stray reflected light, or an out-of-range LED current,
saturates the optical detector. The clot-detection algorithm interprets the
plateau as an immediate clot and reports a falsely short PT.

## Pre-Mitigation Assessment

- **Severity (9)**: A false PT can directly influence anticoagulant dosing. ISO 14971
  severity table maps misdiagnosis-leading-to-treatment-error to S5/S6, the
  device's risk policy converts that to 9 on the 1–10 scale.
- **Probability (3)**: Saturation is rare in normal operation but plausible under
  optical drift, contamination, or reagent batch variance.
- **Detection (5)**: Without the guard, saturated traces look superficially like
  valid fast clots; operators are unlikely to catch them.

## Risk Controls

Implemented by:

- **REQ-SW-AC-005** — saturation guard suppresses the result and emits
  SENSOR_SATURATION when the ADC reading hits the top 2 % of full scale.
- **REQ-SW-AC-003** — built-in QC chain catches measurement drift that would
  otherwise mask saturation in marginal cases.

Verified by:

- **TC-INT-001** — injected saturated trace, expected suppression.
- **TC-INT-002** — drifted control material, expected QC_FAIL.

## Post-Mitigation Assessment

Probability reduced from 3 to 1 because the saturation guard is exhaustive and
the QC chain offers an independent check. Residual severity is unchanged
(misdiagnosis remains the failure mode if controls failed). Residual risk
acceptable per ISO 14971 risk policy.
