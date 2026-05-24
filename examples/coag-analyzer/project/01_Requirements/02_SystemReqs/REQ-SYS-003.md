---
id: REQ-SYS-003
type: system-requirement
status: baselined
priority: must
category: non-functional
source: [STK-003]
rationale: Sets the binding analytical-performance target for the device.
verification_method: test
risks: []
tests: [TC-INT-002]
created: 2026-05-24
updated: 2026-05-24
approver: QA Manager
---

# Analytical reproducibility (CV ≤ 5 %)

## Description

The system SHALL achieve a coefficient of variation (CV) ≤ 5 % for duplicate PT
measurements of the same control material in the normal range (10–14 s).

## Acceptance Criteria

- For each of three reference materials (low, normal, high), CV across 20
  duplicate measurements is ≤ 5 %.
- The instrument logs raw clot-detection traces for every measurement to allow
  offline re-analysis of borderline cases.
