---
id: FMEA-002
type: fmea-entry
status: controlled
hazard: Patient sample mix-up due to barcode misread
hazardous_situation: A sample is loaded against the wrong patient identifier because the barcode is misread without detection.
harm: Result is reported against the wrong patient; clinical decisions are made on data that does not belong to that patient.
severity: 8
probability: 4
detection: 4
rpn: 128
controls: [REQ-SW-AC-001]
residual_severity: 8
residual_probability: 1
residual_acceptable: true
related_requirements: [REQ-SYS-001]
tests: [TC-UNIT-001]
created: 2026-05-24
updated: 2026-05-24
approver: Risk Manager
---

# FMEA-002: Barcode-mediated sample mix-up

## Hazard Description

A patient sample is associated with the wrong patient ID because the barcode is
misread (smudged label, partial scan, wrong-format barcode) and the system
accepts the misread without detection.

## Pre-Mitigation Assessment

- **Severity (8)**: Misattributed results lead to clinical decisions on the wrong
  patient. Severity does not reach 9 because most coagulation errors are
  recoverable if caught at the reporting stage; nevertheless harm is plausible.
- **Probability (4)**: Barcode misreads in lab environments are common
  (smudge, contamination, partial occlusion).
- **Detection (4)**: An invisible misread (consistent but wrong barcode) is hard
  to catch by inspection.

## Risk Controls

Implemented by:

- **REQ-SW-AC-001** — barcode workflow rejects invalid barcodes before the
  CONFIRM_POSITION transition; checksum on the barcode payload catches
  truncated reads.

Verified by:

- **TC-UNIT-001** — barcode state-machine unit test exercises rejection paths.

## Post-Mitigation Assessment

Probability reduced from 4 to 1 by the checksum gate. Residual severity
unchanged. Residual risk acceptable per ISO 14971 risk policy.
