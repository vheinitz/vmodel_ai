---
id: TC-INT-001
type: test-case
level: integration
status: passing
verifies: [REQ-SW-AC-005, REQ-SYS-005]
mitigates: [FMEA-001]
preconditions: AC built on bench rig with stubbed optical front-end able to inject arbitrary ADC traces.
steps: |
  1. Configure AC in normal mode, QC chain in PASS state.
  2. Inject a synthetic saturated optical trace via the stub (ADC values pinned to 99 % of full-scale).
  3. Observe AC outputs: result publish stream and audit log.
  4. Inject a non-saturated trace immediately after; observe normal result publication resumes.
expected_result: |
  - No PT result is published for the saturated trace.
  - A SENSOR_SATURATION event appears in the audit log with raw trace ID.
  - The subsequent non-saturated trace publishes a result normally.
last_run: 2026-05-24
last_result: pass
created: 2026-05-24
updated: 2026-05-24
---

# TC-INT-001: Optical-sensor saturation suppression

## Notes

Integration-level verification of the saturation guard in REQ-SW-AC-005 and
mitigation evidence for FMEA-001.
