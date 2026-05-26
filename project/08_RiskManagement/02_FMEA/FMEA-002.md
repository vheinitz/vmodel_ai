---
id: FMEA-002
type: fmea-entry
status: draft
hazard: Container dislodged during mixing causing biohazardous spill
hazardous_situation: Standard lab tube or small container is not held securely by the mixing mechanism. During operation, the container becomes loose, tips over, or is ejected. Liquid sample (potentially infectious) spills onto the device, workbench, or operator.
harm: Operator exposure to potentially infectious patient material (bloodborne pathogens). Cross-contamination of work area. Loss of patient sample requiring recollection.
severity: 7
probability: 3
detection: 6
rpn: 126
controls: [REQ-SYS-020, REQ-SYS-040]
residual_severity: 7
residual_probability: 3
residual_acceptable: false
related_requirements: [REQ-SYS-020, REQ-SYS-040]
tests: []
created: 2026-05-26
updated: 2026-05-26
approver: Risk Manager
---

# FMEA-002: Container Dislodged During Mixing

## Function
Secure holding of standard lab tubes and containers during mixing (STK-002)

## Failure Mode
Tube or container is not adequately secured and becomes dislodged, tips over, or is ejected from the mixing position during operation.

## Cause
- Holding mechanism does not accommodate the specific tube diameter/shape
- User inserts tube incorrectly (not fully seated)
- Holding mechanism spring/friction degrades over time
- Excessive mixing speed causes tube to walk out of holder
- Tube cap not properly closed → liquid escapes even if tube stays in place

## Effect
- Biohazardous liquid spill on device, workbench, or operator
- Operator exposure to infectious material
- Loss of patient sample (recollection needed)
- Cross-contamination of work area
- Device requires decontamination before further use

## Risk Control (Proposed)
1. **Design**: Mechanical interlock — mixing cannot start unless container is detected as properly seated; enclosed mixing chamber with transparent lid; lid interlock prevents opening during operation
2. **Protective**: Splash guard / sealed mixing chamber contains any spill within the device; automatic stop if lid opened during operation
3. **Information**: Markings showing correct insertion position; user manual with tube compatibility list

## Verification
- Test with range of standard tube types at maximum mixing speed — verify no dislodging
- Lid interlock test — verify mixing stops when lid opened
- Spill containment test — simulate tube failure inside closed chamber
