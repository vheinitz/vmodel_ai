---
id: REQ-SYS-040
type: system-requirement
status: draft
priority: must
category: safety
source: [STK-004]
rationale: Patient samples may contain infectious agents. An enclosed mixing chamber is the primary safety barrier preventing operator exposure to biohazardous splashes, aerosols, and spills during mixing.
verification_method: test
risks: [FMEA-004, FMEA-005]
tests: []
created: 2026-05-26
updated: 2026-05-26
approver: Safety Officer
---

# REQ-SYS-040: Enclosed Mixing Chamber with Safety Interlock

## Requirement

The system shall enclose the mixing area in a transparent, sealed chamber such that:

1. No liquid or aerosol can escape the chamber during a complete mixing cycle, including a simulated container failure (tube rupture or cap-off condition) at maximum operating speed.
2. A lid interlock shall prevent the mixing mechanism from operating when the lid is not fully closed.
3. The lid interlock shall prevent the lid from being opened while the mixing mechanism is in motion.
4. After mixing stops (normal completion or emergency stop), the lid shall remain locked for a minimum of 3 seconds to allow aerosols to settle.
5. The chamber interior shall be visible through the transparent lid for operator inspection without opening.

## Rationale

This is the primary risk control for the most severe hazard in this device: operator exposure to biohazardous material. A fully enclosed chamber with interlocked lid provides inherent safety by design (control hierarchy level 1) — physically separating the operator from the hazard. The post-mixing settling delay addresses aerosol exposure, a frequently overlooked hazard in mixer design.

## Verification

- Container failure simulation: intentionally rupture a liquid-filled tube inside the closed chamber — verify zero liquid/aerosol escape (fluorescent tracer + UV inspection)
- Lid interlock test: attempt to start mixing with lid open → must not start
- Lid interlock test: attempt to open lid during mixing → must not open
- Settling delay test: measure time from motor stop to lid release → ≥ 3 seconds

## Traceability

- **User Need:** STK-004 (Operator Safety — Spill, Splash, Injury Prevention)
- **Risks:** FMEA-004 (Biohazard Exposure), FMEA-005 (Mechanical Injury)
