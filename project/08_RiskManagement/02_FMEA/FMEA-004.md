---
id: FMEA-004
type: fmea-entry
status: draft
hazard: Operator exposure to biohazardous material via splash or aerosol during mixing
hazardous_situation: During mixing, a container leaks, cap opens, or tube breaks. Liquid or aerosol containing potentially infectious patient material escapes the container. If the mixing area is not adequately enclosed, the operator is exposed.
harm: Infection of laboratory staff with bloodborne pathogens (HIV, HBV, HCV) or other infectious agents present in patient samples. Severity ranges from serious illness requiring medical treatment to chronic lifelong condition.
severity: 9
probability: 2
detection: 6
rpn: 108
controls: [REQ-SYS-040]
residual_severity: 9
residual_probability: 2
residual_acceptable: false
related_requirements: [REQ-SYS-040]
tests: []
created: 2026-05-26
updated: 2026-05-26
approver: Risk Manager
---

# FMEA-004: Biohazard Exposure via Splash or Aerosol

## Function
Operator safety — spill, splash, and injury prevention (STK-004)

## Failure Mode
Liquid or aerosol escapes the container during mixing and reaches the operator or surrounding work area.

## Cause
- Tube cap not properly secured → opens during agitation
- Tube wall failure (crack, manufacturing defect)
- Overfilled container → liquid forced out by mixing motion
- Mixing speed too high for container type → aerosol generation
- Container incompatible with mixing motion (e.g., rigid container on vortex mixer)
- Operator opens lid immediately after mixing before aerosols settle

## Effect
- Operator exposure to infectious patient material
- Potential infection with bloodborne pathogens (HIV, HBV, HCV)
- Cross-contamination of laboratory surfaces
- Psychological impact on exposed staff member
- Regulatory reportable incident (occupational exposure)

## Risk Control (Proposed)
1. **Design**: Fully enclosed mixing chamber with transparent lid; lid interlock prevents operation when open and prevents opening during operation; post-mixing settling delay (lid stays locked for e.g. 5 seconds after mixing stops to allow aerosols to settle)
2. **Protective**: Sealed chamber contains any leak internally; drip tray catches liquid for easy decontamination; visual inspection window to check for spills before opening
3. **Information**: Training to check tube caps before insertion; warning label on lid; SOP for spill cleanup

## Verification
- Simulated container failure test inside closed chamber — verify no liquid/aerosol escapes
- Lid interlock timing test — verify delay after stop
- Aerosol containment test with fluorescent tracer
