---
id: REQ-SYS-070
type: system-requirement
status: draft
priority: must
category: functional
source: [STK-006]
rationale: Lab staff need direct, immediate control over mixing. Controls must be simple, clearly identifiable, and not susceptible to accidental activation or ambiguity.
verification_method: test
risks: [FMEA-007, FMEA-008]
tests: []
created: 2026-05-26
updated: 2026-05-26
approver: Lab Director
---

# REQ-SYS-070: Manual Start and Stop Controls

## Requirement

1. **Start Control:** The system shall provide a single, clearly labeled, mechanically-actuated start button (not capacitive touch). The button shall require a deliberate press force ≥ 2 N to prevent accidental activation from incidental contact. The button shall be recessed or guarded to further prevent inadvertent activation.
2. **Stop Control:** The system shall provide a single, clearly labeled stop button, visually distinct from the start button (different color, shape, or position). Activation of the stop button shall immediately terminate the mixing cycle — stopping motor power within 100 ms.
3. **Control Placement:** Start and stop controls shall be located on the front panel of the device, reachable without the operator reaching over or near the mixing area.
4. **Control During Operation:** During an active mixing cycle, pressing the start button again shall have no effect (no double-start or mode change). Only the stop button or emergency stop shall terminate the cycle.

## Rationale

Simplicity and reliability of controls are essential for safety and usability. Mechanical buttons provide tactile feedback and are less susceptible to false triggering from liquid splashes or cleaning cloths compared to capacitive touch controls. The 100 ms stop response time ensures the operator can intervene quickly.

## Verification

- Start button force test: measure actuation force → ≥ 2 N
- Accidental activation test: apply glancing contact (simulating bump/reach) → must not trigger
- Stop response test: measure time from stop button press to motor power interruption → ≤ 100 ms
- Double-start rejection test: press start during mixing → verify no effect
- Ergonomic assessment: operator reaches controls without crossing mixing area

## Traceability

- **User Need:** STK-006 (Manual Start and Stop Control)
- **Risks:** FMEA-007 (Inability to Stop), FMEA-008 (Accidental Start)
