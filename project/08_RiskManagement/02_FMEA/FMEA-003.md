---
id: FMEA-003
type: fmea-entry
status: draft
hazard: Electric shock from device
hazardous_situation: Electrical insulation failure, liquid ingress into electronics, damaged power cord, or improper grounding exposes operator to mains voltage through accessible conductive parts of the device.
harm: Electric shock causing injury to operator — ranging from startle reaction (leading to secondary injury) to cardiac effects depending on current path and duration.
severity: 8
probability: 2
detection: 7
rpn: 112
controls: [REQ-SYS-030]
residual_severity: 8
residual_probability: 2
residual_acceptable: false
related_requirements: [REQ-SYS-030]
tests: []
created: 2026-05-26
updated: 2026-05-26
approver: Risk Manager
---

# FMEA-003: Electric Shock

## Function
Electric-powered operation (STK-003)

## Failure Mode
Operator receives electric shock from accessible conductive parts of the device.

## Cause
- Liquid spill reaches internal electronics (cleaning or sample spill)
- Power cord damaged (cuts, fraying, internal wire breakage)
- Insulation breakdown in motor or transformer
- Improper grounding (earth connection fault)
- Device opened by unauthorized person exposing live parts
- Condensation inside device due to temperature/humidity cycling

## Effect
- Electric shock to operator — severity ranges from startle to serious injury
- Secondary injury from involuntary movement (striking nearby objects)
- Device becomes unusable until repaired
- Potential for fire if short circuit occurs

## Risk Control (Proposed)
1. **Design**: Double/reinforced insulation (Class II construction); sealed electronics compartment (IPX4 minimum for spill protection); strain-relieved power cord entry; no user-accessible live parts
2. **Protective**: Residual-current device (RCD/GFCI) in mains plug or inlet; overcurrent protection (fuse); automatic power disconnect on earth leakage
3. **Information**: Warning label "Do not open — risk of electric shock"; instruction in manual to inspect power cord before each use; cleaning procedure specifying device must be unplugged

## Verification
- Dielectric strength test (hipot) per IEC 61010-1
- Earth continuity test (if Class I)
- IPX4 spill test on electronics compartment
- Visual inspection of cord strain relief
