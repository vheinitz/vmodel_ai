---
id: COMP-002
type: architecture-component
layer: system
status: draft
realizes: [REQ-SYS-010, REQ-SYS-020]
interfaces: [IF-MOTOR]
created: 2026-05-26
updated: 2026-05-26
---

# COMP-002: Mixing Assembly

## Layer
System (Electromechanical)

## Responsibility
The Mixing Assembly converts electrical power into controlled mechanical motion to mix liquids. It consists of a DC motor, a mixing platform (vortex cup or orbital plate), and a tube/container holding mechanism. The assembly must securely hold standard lab tubes and produce consistent, uniform mixing.

## Safety Class
B — mechanical failure could cause non-uniform mixing (wrong result) or container ejection (biohazard)

## Sub-Components
- **DC Motor**: Brushed or brushless DC motor with tachometer feedback for speed monitoring
- **Mixing Platform**: Vortex cup (for single-tube vortex mixing) or orbital platform (for multiple tubes) — design choice TBD
- **Tube Holder**: Spring-loaded or friction-fit mechanism accepting tubes Ø 13–30 mm, height ≤ 120 mm

## Interfaces

| Interface | Direction | Connected To | Description |
|-----------|-----------|-------------|-------------|
| IF-MOTOR | Input | COMP-001 (CCU) | PWM speed command, direction, enable signal; tachometer feedback |

## Key Design Constraints
- Maximum speed: sufficient for vortex mixing of aqueous solutions (typically 1500–3000 RPM)
- Tube holder must prevent dislodging at maximum speed (tested per REQ-SYS-020)
- Mechanical stop time ≤ 1 second from motor disable (per REQ-SYS-050)
- All accessible surfaces smooth (Ra ≤ 0.8 µm) per REQ-SYS-060
