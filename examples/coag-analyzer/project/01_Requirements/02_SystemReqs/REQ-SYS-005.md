---
id: REQ-SYS-005
type: system-requirement
status: baselined
priority: must
category: safety
source: [STK-005]
rationale: Encodes the patient-safety need into a binding system behavior.
verification_method: test
risks: [FMEA-001]
tests: [TC-INT-001]
created: 2026-05-24
updated: 2026-05-24
approver: Regulatory Affairs
---

# Suppress QC-failing results

## Description

The system SHALL NOT publish a PT result whose internal quality control chain
has not passed. Where validity cannot be established, the system SHALL mark
the result invalid and notify the operator.

## Acceptance Criteria

- For every published result, an audit record links the result to the
  QC-chain pass that authorized its publication.
- A simulated QC failure (forced via diagnostic mode) results in result
  suppression and a visible operator notification.
- No reported result has ever bypassed the QC chain in the verification run.
