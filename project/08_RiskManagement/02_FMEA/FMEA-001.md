---
id: FMEA-001
type: fmea-entry
status: draft
hazard: Non-uniform or inconsistent liquid mixing leading to incorrect diagnostic results
hazardous_situation: Mixing mechanism fails to produce homogeneous sample (due to insufficient speed, wrong duration, mechanical wear, or incorrect settings). Lab staff pipette from a non-homogeneous sample for downstream analysis. Concentration gradient in the sample produces a measurement that does not represent the true analyte concentration.
harm: Wrong clinical decision based on incorrect diagnostic result — delayed treatment, unnecessary retesting, or missed diagnosis. For safety class B device, harm is non-serious reversible injury or clinical inconvenience.
severity: 6
probability: 4
detection: 5
rpn: 120
controls: [REQ-SYS-010]
residual_severity: 6
residual_probability: 4
residual_acceptable: false
related_requirements: [REQ-SYS-010]
tests: []
created: 2026-05-26
updated: 2026-05-26
approver: Risk Manager
---

# FMEA-001: Non-Uniform Mixing

## Function
Uniform and consistent liquid mixing (STK-001)

## Failure Mode
The mixing process does not produce a homogeneous sample. Liquids remain layered or sedimented, resulting in concentration gradients within the tube.

## Cause
- Mixing speed too low or inconsistent due to motor degradation
- Mixing duration insufficient for the liquid type
- Mechanical wear in mixing mechanism (bearing failure, imbalance)
- Incorrect user setting for tube/liquid type
- Overloading (container too large or too full)

## Effect
- Diagnostic analysis of the poorly-mixed sample returns incorrect result
- Repeat analysis required → delayed clinical decision
- If error goes undetected → wrong clinical decision, potential patient harm

## Risk Control (Proposed)
1. **Design**: Fixed mixing parameters validated for standard use cases; no user adjustment of critical parameters (design out use error)
2. **Protective**: Motor speed monitoring with out-of-range alarm; optical or vibration-based mixing completeness check
3. **Information**: Instruction in user manual on correct tube filling level and compatible container types

## Verification
- Performance test with calibrated non-homogeneous samples to verify mixing completeness
- Accelerated life test of mixing mechanism to verify consistency over device lifetime
