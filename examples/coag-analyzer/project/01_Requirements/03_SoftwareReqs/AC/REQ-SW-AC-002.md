---
id: REQ-SW-AC-002
type: software-requirement
component: AC
status: baselined
priority: must
category: non-functional
source: [REQ-SYS-002]
rationale: Allocates the system-level 12-minute budget across AC's scheduling responsibilities.
verification_method: test
risks: []
tests: [TC-SYS-001]
created: 2026-05-24
updated: 2026-05-24
approver: Software Architect
---

# AC: Scheduled measurement budget

## Description

The AC SHALL schedule reagent dispense, mixing and optical measurement such that
the elapsed time from sample-load to result-ready is ≤ 10 minutes per sample on
the reference benchmark workload.

## Acceptance Criteria

- The system-level acceptance test TC-SYS-001 passes the 12-minute end-to-end target,
  of which AC contributes ≤ 10 minutes by design.
- AC emits a per-stage timing record for every run.
