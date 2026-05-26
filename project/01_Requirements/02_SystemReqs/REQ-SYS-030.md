---
id: REQ-SYS-030
type: system-requirement
status: draft
priority: must
category: safety
source: [STK-003, STK-004]
rationale: Electrical safety is a basic regulatory requirement for mains-powered laboratory equipment. Liquid spills in a medical lab environment create an elevated risk of electric shock if the device is not properly protected.
verification_method: test
risks: [FMEA-003]
tests: []
created: 2026-05-26
updated: 2026-05-26
approver: Safety Officer
---

# REQ-SYS-030: Electrical Safety

## Requirement

The system shall comply with IEC 61010-1 (Safety requirements for electrical equipment for measurement, control, and laboratory use). Specifically:

1. The electronics enclosure shall provide ingress protection of at least IPX4 (protected against splashing water from any direction) to prevent liquid ingress from sample spills or cleaning.
2. Accessible conductive parts shall be separated from mains voltage by double or reinforced insulation (Class II construction) or shall be reliably connected to protective earth (Class I).
3. The mains power inlet shall include overcurrent protection (fuse) and strain relief on the power cord.
4. Leakage current shall not exceed 0.5 mA (Class II) or 3.5 mA (Class I) under normal condition.

## Rationale

An electric shock from laboratory equipment is a serious, potentially life-threatening event. In a medical lab where liquid spills are routine, the device must be designed so that a foreseeable spill cannot create a shock hazard. IEC 61010-1 is the harmonized standard for laboratory equipment safety.

## Verification

- Dielectric strength test (hipot) per IEC 61010-1
- Earth continuity test (if Class I)
- IPX4 water spray test on electronics enclosure
- Leakage current measurement
- Visual inspection of cord strain relief

## Traceability

- **User Needs:** STK-003 (Electric-Powered Operation), STK-004 (Operator Safety)
- **Risk:** FMEA-003 (Electric Shock)
