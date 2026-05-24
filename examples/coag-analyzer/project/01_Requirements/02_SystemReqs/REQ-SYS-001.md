---
id: REQ-SYS-001
type: system-requirement
status: baselined
priority: must
category: functional
source: [STK-001]
rationale: Translates the technician-experience need into a measurable system behavior.
verification_method: test
risks: []
tests: [TC-SYS-001]
created: 2026-05-24
updated: 2026-05-24
approver: System Architect
---

# Sample-load interaction budget

## Description

The system SHALL allow a trained technician to load a sample tube and start a
measurement run with no more than three discrete UI interactions (e.g. scan,
confirm, start).

## Acceptance Criteria

- A documented "happy-path" sequence exists describing exactly three operator interactions.
- A usability evaluation per IEC 62366 with five representative users shows ≥ 80 %
  completion of the happy-path sequence on first attempt without prompts.

## Notes

This is a functional requirement; usability/training metrics live in the PQ protocol.
