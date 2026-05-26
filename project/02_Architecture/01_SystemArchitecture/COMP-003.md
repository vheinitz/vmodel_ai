---
id: COMP-003
type: architecture-component
layer: system
status: draft
realizes: [REQ-SYS-040, REQ-SYS-050, REQ-SYS-060, REQ-SYS-070, REQ-SYS-080]
interfaces: [IF-SAFETY, IF-UI]
created: 2026-05-26
updated: 2026-05-26
---

# COMP-003: Safety Enclosure & User Interface

## Layer
System (Electromechanical / Physical)

## Responsibility
The Safety Enclosure & UI subsystem provides the physical safety barriers, operator controls, and status indicators. It separates the operator from the mixing hazard, provides emergency stop capability, and communicates device state to the operator.

## Safety Class
B — failure of safety interlocks could expose operator to biohazard (splash/aerosol) or mechanical injury

## Sub-Components

### Safety Enclosure
- **Transparent Lid**: Polycarbonate, sealed against the mixing chamber with silicone gasket
- **Lid Interlock**: Mechanical switch (NC contact) detecting lid-closed state; directly wired to motor enable circuit (hardware interlock, not software-only)
- **Mixing Chamber**: Smooth-walled interior (Ra ≤ 0.8 µm), drip tray, no crevices or sharp corners
- **Post-Mixing Settling Delay**: Lid lock solenoid holds lid closed for 3 seconds after motor stop

### User Interface
- **Start Button**: Recessed mechanical pushbutton, actuation force ≥ 2 N, green cap
- **Stop Button**: Mechanical pushbutton, red cap, visually distinct from start
- **Emergency Stop**: Red mushroom-head button, NC contacts directly in motor power path (hardware-level)
- **Status LED**: RGB LED (or separate green/red LEDs) — green steady = ready/done, green flashing = running, red flashing = error
- **Buzzer**: Piezo buzzer for audible error alarm, ≥ 65 dBA at 1 m

## Interfaces

| Interface | Direction | Connected To | Description |
|-----------|-----------|-------------|-------------|
| IF-SAFETY | Output | COMP-001 (CCU) | Lid interlock status, emergency stop status |
| IF-UI | Input/Output | COMP-001 (CCU) | Button press signals (in), LED drive signals (out), buzzer drive (out) |

## Key Design Constraints
- Lid interlock must prevent operation when lid open AND prevent lid opening during operation (dual function)
- Emergency stop must interrupt motor power via hardware (no software in path)
- All indicators visible at 3 m, 500 lux, ±45° (per REQ-SYS-080)
- Chamber interior cleanable without tools, ≤ 2 minutes (per REQ-SYS-060)
