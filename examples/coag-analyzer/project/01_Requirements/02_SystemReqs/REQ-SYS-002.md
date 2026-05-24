---
id: REQ-SYS-002
type: system-requirement
status: baselined
priority: must
category: non-functional
source: [STK-002]
rationale: Sub-15-minute turnaround is a contractual lab commitment derived from the stakeholder need.
verification_method: test
risks: []
tests: [TC-SYS-001]
created: 2026-05-24
updated: 2026-05-24
approver: System Architect
---

# 12-minute PT result budget

## Description

The system SHALL produce a PT result, end to end from sample-load to result-publish,
within 12 minutes at the 95th percentile across a 100-sample acceptance run.

## Acceptance Criteria

- Measured P95 turnaround across the acceptance run is ≤ 12 minutes.
- No individual run exceeds 15 minutes.
- The instrument logs per-run timing breakdowns (load → mix → measure → publish).

## Notes

The 12-minute target leaves a 3-minute margin against the stakeholder's 15-minute
turnaround need to absorb pre-analytical variability.
