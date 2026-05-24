---
id: REQ-SW-AC-005
type: software-requirement
component: AC
status: baselined
priority: must
category: safety
safety_class: B
source: [REQ-SYS-005]
rationale: Optical-sensor saturation is the dominant identified path to silently incorrect PT results.
verification_method: test
risks: [FMEA-001]
tests: [TC-INT-001]
created: 2026-05-24
updated: 2026-05-24
approver: Regulatory Affairs
---

# AC: Optical-sensor saturation guard

## Description

The AC SHALL inspect every optical-sensor measurement for saturation (ADC value
within the top 2 % of full scale) and SHALL suppress the resulting PT value when
saturation is detected. A SENSOR_SATURATION event SHALL be emitted and recorded
in the audit log.

## Acceptance Criteria

- Integration test injects a saturated trace; AC suppresses the result and emits
  SENSOR_SATURATION.
- The audit log records the saturated measurement with timestamp and raw trace ID.
- No saturated measurement has ever been published in the verification run.
