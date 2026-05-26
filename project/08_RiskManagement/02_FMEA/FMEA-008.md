---
id: FMEA-008
type: fmea-entry
status: draft
hazard: Accidental or unauthorized start of mixing
hazardous_situation: The mixing process starts without operator intent — due to accidental bump of the start control, electrical noise triggering the start circuit, or someone pressing start while another operator's hands are near the mixing area. Device begins mixing with operator in unsafe position.
harm: Mechanical injury (pinch, strike) to operator whose hands are near mixing area. Startle reaction. Potential for container ejection if not properly seated when mixing begins.
severity: 5
probability: 3
detection: 5
rpn: 75
controls: [REQ-SYS-040, REQ-SYS-070]
residual_severity: 5
residual_probability: 3
residual_acceptable: false
related_requirements: [REQ-SYS-070]
tests: []
created: 2026-05-26
updated: 2026-05-26
approver: Risk Manager
---

# FMEA-008: Accidental or Unauthorized Start

## Function
Manual start and stop control (STK-006)

## Failure Mode
The mixing process starts without the operator's deliberate intent.

## Cause
- Start button too sensitive or protruding — accidentally pressed when reaching near device
- Electrical noise or contact bounce interpreted as start command
- No lid-closed interlock — mixing starts with lid open
- Capacitive touch control triggered by cleaning cloth or liquid splash
- Device left powered on — someone unfamiliar activates it

## Effect
- Operator injury if hands are inside mixing area when it starts
- Container not properly seated → ejection or spill when mixing begins
- Startle reaction → drop samples or other equipment
- Unattended mixing of unknown duration

## Risk Control (Proposed)
1. **Design**: Lid-closed interlock — mixing cannot start unless lid is fully closed; start button recessed or guarded to prevent accidental activation; mechanical (not capacitive) start button requiring deliberate press force > 2 N; two-hand operation not required for simple mixer (usability vs safety trade-off)
2. **Protective**: Power-on self-test verifies safety interlocks functional before enabling operation; automatic stop if lid interlock signal lost during operation
3. **Information**: Instruction to power off device when not in use

## Verification
- Attempt start with lid open — verify device does not start
- Drop test / bump test on start button — verify does not trigger from accidental contact
- Electrical noise immunity test (IEC 61326-1)
