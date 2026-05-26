---
id: FMEA-009
type: fmea-entry
status: draft
hazard: Fault condition not indicated to operator — wrong result used clinically
hazardous_situation: An error condition occurs during mixing (motor stall, speed out of range, timeout) but the device does not signal the error to the operator. The operator assumes mixing completed successfully. Poorly-mixed sample is forwarded for diagnostic analysis.
harm: Diagnostic analysis of non-homogeneous or incorrectly processed sample produces wrong result. Clinical decision based on wrong result leads to missed diagnosis or unnecessary treatment.
severity: 6
probability: 3
detection: 4
rpn: 72
controls: [REQ-SYS-080]
residual_severity: 6
residual_probability: 3
residual_acceptable: false
related_requirements: [REQ-SYS-080]
tests: []
created: 2026-05-26
updated: 2026-05-26
approver: Risk Manager
---

# FMEA-009: Undetected Fault Condition

## Function
Operational status indication (STK-007)

## Failure Mode
The device experiences an internal fault (motor stall, speed deviation, premature stop, timeout) but does not provide an error indication distinguishable from normal completion. The operator believes mixing was successful.

## Cause
- Status LED fails (burned out, disconnected)
- Software does not detect the fault condition (no speed monitoring)
- Error state and "done" state use same or similar indication (ambiguity)
- Buzzer/speaker fails
- Operator misinterprets the indication (e.g., thinks flashing means done when it means error)
- Status indication not visible from operator's working position

## Effect
- Faulty sample forwarded for analysis → wrong diagnostic result
- Delayed discovery of device fault → multiple samples affected before problem noticed
- Loss of confidence in device reliability

## Risk Control (Proposed)
1. **Design**: Distinct visual AND audible signals for each state — green steady = done, green flashing = running, red flashing + audible alarm = error; self-test of indicator LED and buzzer at power-on; motor speed monitoring with automatic error detection
2. **Protective**: Error latch — once error detected, device locks out further operation until power-cycled or error acknowledged by operator; automatic stop on motor speed deviation > 20% from target
3. **Information**: Quick-reference card showing what each signal pattern means; user manual with troubleshooting guide

## Verification
- Fault injection test — simulate motor stall, verify red alarm activates
- Ambient light test — verify indicators visible at 500 lux room lighting from 3 m
- Audible alarm test — verify sound level ≥ 65 dBA at 1 m
- Power-on self-test verification
