---
id: FMEA-007
type: fmea-entry
status: draft
hazard: Inability to stop mixing during an emergency
hazardous_situation: Operator observes a problem during mixing (container leaking, tube dislodged, unusual noise, smoke) and attempts to stop the device. The stop control fails to respond — either due to control malfunction, software freeze, or the stop function being buried in a menu. Mixing continues, escalating the hazardous situation.
harm: Escalation of whatever hazard triggered the stop attempt — biohazard exposure from continuing spill, mechanical injury from continuing operation, or fire/electrical hazard. Operator may attempt risky manual intervention (reaching into running device).
severity: 7
probability: 2
detection: 4
rpn: 56
controls: [REQ-SYS-050, REQ-SYS-070]
residual_severity: 7
residual_probability: 2
residual_acceptable: false
related_requirements: [REQ-SYS-050, REQ-SYS-070]
tests: []
created: 2026-05-26
updated: 2026-05-26
approver: Risk Manager
---

# FMEA-007: Inability to Stop Mixing

## Function
Manual start and stop control (STK-006)

## Failure Mode
The stop control does not immediately terminate the mixing process when activated by the operator.

## Cause
- Stop button/switch mechanical failure (stuck, broken contacts)
- Software crash or freeze prevents processing of stop command
- Stop function implemented in software only — no hardware interrupt path
- Stop button not clearly distinguishable from other controls
- Stop button positioned where operator cannot reach it quickly
- Control board failure

## Effect
- Mixing cannot be stopped during emergency → hazard escalates
- Operator may attempt to unplug device (electric shock risk) or open lid by force (mechanical injury + biohazard risk)
- Delayed response to spill, tube failure, or other fault condition

## Risk Control (Proposed)
1. **Design**: Hardware-level emergency stop — dedicated NC (normally-closed) stop switch directly interrupts motor power (does not rely on software); prominent red stop button on front panel; stop also triggered by lid opening (redundant stop path)
2. **Protective**: Watchdog timer — if software does not respond within timeout, hardware disables motor power
3. **Information**: Operator training on emergency stop location and function; "How to Stop" quick-reference label on device

## Verification
- Stop button function test — verify motor power interrupted within 100 ms of button press
- Software crash simulation — verify watchdog disables motor
- Lid-open stop test — verify motor stops on lid opening
