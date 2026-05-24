---
id: TC-UNIT-001
type: test-case
level: unit
status: passing
verifies: [REQ-SW-AC-001]
mitigates: [FMEA-002]
preconditions: AC barcode state machine instantiated in isolation; no hardware required.
steps: |
  1. Feed a valid 13-character barcode with correct checksum; assert transition SCAN_BARCODE -> CONFIRM_POSITION.
  2. Feed an invalid-checksum barcode; assert state stays in SCAN_BARCODE and a BARCODE_REJECTED event is emitted.
  3. Feed a truncated barcode; assert rejection.
  4. From CONFIRM_POSITION, feed an OPERATOR_CONFIRM event; assert transition to START_RUN.
expected_result: All three rejection paths leave the machine in SCAN_BARCODE; the valid path reaches START_RUN in three events.
last_run: 2026-05-24
last_result: pass
created: 2026-05-24
updated: 2026-05-24
---

# TC-UNIT-001: Barcode state machine

## Notes

Unit-level verification of the AC barcode workflow contract from REQ-SW-AC-001
and mitigation evidence for FMEA-002 (barcode misread → sample mix-up).
