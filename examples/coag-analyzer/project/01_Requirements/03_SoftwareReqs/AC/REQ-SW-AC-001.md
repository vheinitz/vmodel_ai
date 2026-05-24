---
id: REQ-SW-AC-001
type: software-requirement
component: AC
status: baselined
priority: must
category: functional
source: [REQ-SYS-001]
rationale: Implements the three-interaction sample-load workflow at the AC component level.
verification_method: test
risks: [FMEA-002]
tests: [TC-UNIT-001]
created: 2026-05-24
updated: 2026-05-24
approver: Software Architect
---

# AC: Barcoded sample-load workflow

## Description

The Analysis Controller (AC) software SHALL implement the sample-load workflow as
a three-step state machine: SCAN_BARCODE → CONFIRM_POSITION → START_RUN.
Each transition SHALL be triggerable by exactly one operator interaction.

## Acceptance Criteria

- Unit tests exercise each state transition; no transition consumes more than one input event.
- Invalid barcodes are rejected before CONFIRM_POSITION; the state machine returns
  to SCAN_BARCODE.
- A run cannot start without a successful barcode scan.
