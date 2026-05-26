---
id: FMEA-005
type: fmea-entry
status: draft
hazard: Mechanical injury from moving parts
hazardous_situation: Operator places hand or finger into the mixing area while the device is operating. Moving mechanism (vortex cup, orbital platform, roller) strikes or pinches the operator's hand/finger. Alternatively, operator touches oscillating mechanism during cleaning or tube insertion/removal.
harm: Bruising, laceration, pinch injury, or skin abrasion to fingers or hand. In severe case, fracture of small bones in hand. Non-permanent injury requiring first aid or minor medical attention.
severity: 5
probability: 4
detection: 4
rpn: 80
controls: [REQ-SYS-040, REQ-SYS-050]
residual_severity: 5
residual_probability: 4
residual_acceptable: false
related_requirements: [REQ-SYS-040, REQ-SYS-050]
tests: []
created: 2026-05-26
updated: 2026-05-26
approver: Risk Manager
---

# FMEA-005: Mechanical Injury from Moving Parts

## Function
Operator safety — injury prevention (STK-004) and manual stop control (STK-006)

## Failure Mode
Operator's hand or finger contacts moving parts of the mixing mechanism during operation.

## Cause
- No enclosure or guard over mixing area (open design)
- Lid interlock missing or defeated
- Operator reaches in to adjust tube during mixing
- Operator attempts to remove tube immediately after stop while mechanism still decelerating
- Emergency stop not provided or operator does not know how to use it

## Effect
- Pinch injury or bruising to fingers/hand
- Laceration if sharp edges present
- Startle reaction may cause secondary injury (knocking over other equipment)
- Lost work time for injured staff member

## Risk Control (Proposed)
1. **Design**: Enclosed mixing chamber with lid interlock (same as FMEA-004); rounded edges on all accessible parts; no accessible moving parts during operation; mechanism braking to full stop within 1 second of lid opening or stop command
2. **Protective**: Emergency stop button (easily accessible); automatic stop on lid opening
3. **Information**: Warning label near mixing area; instruction not to reach into device while running

## Verification
- Finger-probe test (IEC 61010-1) — verify no accessible moving parts
- Stop time measurement — verify full stop within 1 second
- Lid interlock response time test
