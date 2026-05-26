---
id: REQ-SYS-050
type: system-requirement
status: draft
priority: must
category: safety
source: [STK-004, STK-006]
rationale: Even with an enclosed chamber, the operator needs a fast, reliable way to stop the device in an emergency. A hardware-level emergency stop provides a redundant safety path independent of software.
verification_method: test
risks: [FMEA-005, FMEA-007]
tests: []
created: 2026-05-26
updated: 2026-05-26
approver: Safety Officer
---

# REQ-SYS-050: Emergency Stop and Mechanical Safeguarding

## Requirement

1. **Emergency Stop:** The system shall include a prominent, red, mushroom-head emergency stop button on the front panel that directly interrupts motor power via hardware (not software-mediated). Activation of the emergency stop shall bring all moving parts to a complete stop within 1 second.
2. **Mechanical Safeguarding:** No accessible moving parts shall be reachable by a standard test finger (IEC 61010-1 test probe) during normal operation.
3. **Guard Integrity:** The mixing mechanism shall be mechanically guarded such that the operator cannot reach the mixing area without opening the lid, which triggers the interlock (REQ-SYS-040).
4. **Restart Prevention:** After an emergency stop activation, the system shall require a deliberate two-step restart sequence: (a) release/reset the emergency stop button, (b) press the start button. The system shall not auto-restart on emergency stop release alone.

## Rationale

The emergency stop is the operator's last-resort safety control. It must be hardware-based because software can fail (freeze, crash, or miss the stop command). The two-step restart prevents surprise restart when the emergency stop is reset. This follows the control hierarchy: protective measure backed by design.

## Verification

- Emergency stop activation test: measure time from button press to complete motor stop — ≤ 1 second
- Test finger probe test per IEC 61010-1 — verify no accessible moving parts
- Restart prevention test: activate emergency stop, release it — verify device does NOT start
- Two-step restart test: release emergency stop + press start → verify device starts normally

## Traceability

- **User Needs:** STK-004 (Operator Safety), STK-006 (Manual Start/Stop Control)
- **Risks:** FMEA-005 (Mechanical Injury), FMEA-007 (Inability to Stop)
