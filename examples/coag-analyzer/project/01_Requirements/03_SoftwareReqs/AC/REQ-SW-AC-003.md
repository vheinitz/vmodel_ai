---
id: REQ-SW-AC-003
type: software-requirement
component: AC
status: baselined
priority: must
category: safety
safety_class: B
source: [REQ-SYS-003, REQ-SYS-005]
rationale: Built-in QC is the device's primary defence against silent analytical drift.
verification_method: test
risks: [FMEA-001]
tests: [TC-INT-002]
created: 2026-05-24
updated: 2026-05-24
approver: Regulatory Affairs
---

# AC: Built-in quality control chain

## Description

The AC SHALL run a built-in QC check against the most recent control-material
measurement before publishing a patient result. If the QC check fails or no
recent valid control material exists, the AC SHALL suppress the patient result
and emit an operator-visible QC_FAIL event.

## Acceptance Criteria

- Integration test forces a control-material drift; AC suppresses subsequent
  patient results and emits QC_FAIL.
- Audit records show one QC pass for every published result.
- No result publishes when QC state is `STALE` or `FAILED`.
