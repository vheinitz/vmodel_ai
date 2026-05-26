---
id: REQ-SYS-080
type: system-requirement
status: draft
priority: must
category: non-functional
source: [STK-007]
rationale: Lab staff need unambiguous, at-a-glance awareness of device state to multi-task efficiently and respond promptly to error conditions.
verification_method: test
risks: [FMEA-009]
tests: []
created: 2026-05-26
updated: 2026-05-26
approver: Lab Director
---

# REQ-SYS-080: Operational Status and Fault Indication

## Requirement

1. **State Indication:** The system shall provide a distinct, unambiguous visual signal for each of the following operational states:
   - **Ready/Idle:** Steady green indicator
   - **Mixing in Progress:** Flashing green indicator (1 Hz, 50% duty cycle)
   - **Mixing Complete (Done):** Steady green indicator (same as ready, or optionally a brief double-flash then steady green)
   - **Error/Fault:** Flashing red indicator (2 Hz, 50% duty cycle) accompanied by an audible alarm
2. **Audible Alarm:** The error state shall include an audible alarm with sound pressure level ≥ 65 dBA at 1 meter, distinct from typical lab background noise. The audible alarm shall continue until the operator acknowledges the error or the device is powered off.
3. **Visibility:** All visual indicators shall be clearly visible from a distance of 3 meters at an ambient illumination of 500 lux (typical lab lighting) across a viewing angle of ±45° from the device front.
4. **Power-On Self-Test:** On power-up, the system shall briefly activate all visual and audible indicators (lamp test) so the operator can verify they are functional.

## Rationale

A device without clear status indication forces the operator to stand and watch it — wasting skilled staff time. More critically, an undetected fault (e.g., motor stall during mixing) could produce a poorly-mixed sample that is forwarded for analysis. The distinct error indication with audible alarm ensures faults are noticed promptly.

## Verification

- State indication test: verify correct indicator pattern for each state
- Sound level measurement: ≥ 65 dBA at 1 m in anechoic or quiet (< 40 dBA) conditions
- Visibility test: verify indicators distinguishable at 3 m, 500 lux, ±45° angle
- Power-on self-test: verify all indicators and buzzer activate briefly on power-up
- Fault injection test: simulate motor stall → verify red flashing + audible alarm

## Traceability

- **User Need:** STK-007 (Operational Status Indication)
- **Risk:** FMEA-009 (Undetected Fault Condition)
