---
id: REQ-SYS-020
type: system-requirement
status: draft
priority: must
category: functional
source: [STK-002]
rationale: Standard lab tubes vary in diameter and length. The mixer must securely hold common tube types without custom adapters. A loose container during mixing creates a biohazard spill risk.
verification_method: test
risks: [FMEA-002]
tests: []
created: 2026-05-26
updated: 2026-05-26
approver: Lab Director
---

# REQ-SYS-020: Container Compatibility and Secure Holding

## Requirement

The system shall accept and securely hold standard laboratory tubes and small containers during mixing, including but not limited to: blood collection tubes (Ø 13 mm, 16 mm), microcentrifuge tubes (1.5 mL, 2.0 mL), and reagent vials (up to Ø 30 mm, height ≤ 120 mm). No container shall become dislodged, tipped, or ejected during a complete mixing cycle at maximum operating speed.

## Rationale

Medical laboratories use diverse container types. Requiring proprietary consumables increases cost and workflow friction. More critically, a container that becomes loose during mixing can spill potentially infectious patient material, creating a direct operator safety hazard.

## Verification

- Test each specified tube/container type at maximum mixing speed for 100 cycles
- Verify zero container dislodgements, tip-overs, or ejections
- Visual inspection after each cycle for container position stability

## Traceability

- **User Need:** STK-002 (Compatibility with Standard Lab Tubes)
- **Risk:** FMEA-002 (Container Dislodged → Biohazard Spill)
