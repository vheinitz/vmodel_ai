---
id: TC-SYS-001
type: test-case
level: system
status: passing
verifies: [REQ-SYS-001, REQ-SYS-002, REQ-SW-AC-002]
preconditions: Full assembled instrument on the bench; reference reagent kit; 100 sample tubes prepared per acceptance protocol.
steps: |
  1. Calibrate the instrument per the standard pre-acceptance procedure.
  2. Run the 100-sample acceptance workload, measuring per-sample wall-clock
     time from sample-load to result-publish.
  3. For each sample, record operator interaction count from sample-load
     through to START_RUN.
expected_result: |
  - P95 sample turnaround ≤ 12 minutes; no sample exceeds 15 minutes.
  - 100 % of samples are loaded and started in exactly three operator interactions.
last_run: 2026-05-24
last_result: pass
created: 2026-05-24
updated: 2026-05-24
---

# TC-SYS-001: System throughput and load-interaction acceptance

## Notes

System-level acceptance verifying the throughput target (REQ-SYS-002) and the
three-interaction load workflow (REQ-SYS-001), with AC's scheduling budget
contribution (REQ-SW-AC-002).
