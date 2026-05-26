---
id: COMP-006
type: architecture-component
layer: software
status: draft
realizes: [REQ-SYS-040, REQ-SYS-050]
interfaces: [IF-SAFETY]
created: 2026-05-26
updated: 2026-05-26
---

# COMP-006: Safety Monitor (Firmware Module)

## Layer
Software (Firmware — part of COMP-001 Central Control Unit)

## Responsibility
Continuously monitors safety-critical inputs (lid interlock, emergency stop) and enforces safety constraints regardless of other software state. Implements hardware-backed watchdog timer. This module is the highest-priority software component — its decisions override all other modules.

## Safety Class
B — failure could expose operator to biohazard or mechanical injury

## Key Functions
- **Lid Interlock Monitoring**: Continuous polling of lid-closed switch; if lid opens during operation, immediately signal motor disable via hardware path (GPIO directly gating motor enable line)
- **Emergency Stop Handling**: Emergency stop is wired in hardware (NC contact in motor power path) — software monitors its state for status reporting and restart prevention
- **Post-Mixing Lock**: After motor stop, hold lid lock solenoid energized for 3 seconds (per REQ-SYS-040)
- **Watchdog**: Independent watchdog timer (IWDT) with 500 ms timeout; if not kicked by main loop, triggers system reset
- **Restart Prevention**: After emergency stop or lid-open event, require deliberate two-step sequence before allowing restart (per REQ-SYS-050)
- **Power-On Self-Test**: On boot, verify lid interlock switch transitions, LED/buzzer functionality, watchdog operation

## Interface
| Signal | Direction | Description |
|--------|-----------|-------------|
| LID_CLOSED_IN | Input ← IF-SAFETY | Lid interlock switch (NC = closed, NO = open) |
| ESTOP_IN | Input ← IF-SAFETY | Emergency stop button state (NC = normal, NO = pressed) |
| MOTOR_ENABLE_OUT | Output → IF-MOTOR | Hardware gate for motor power (GPIO, active-low for fail-safe) |
| LID_LOCK_OUT | Output → IF-SAFETY | Lid lock solenoid control |
| SAFETY_FAULT_OUT | Output → COMP-008 | Safety fault signal to Cycle State Machine |

## Design Pattern
**Observer Pattern** — safety monitor continuously observes sensors and publishes safety state to other modules

## Critical Design Rule
The motor enable line (MOTOR_ENABLE_OUT) must be **hardware-OR'd**: motor runs only if BOTH software enable AND lid-closed AND emergency-stop-not-pressed are true. This provides defense-in-depth — even if software crashes, hardware prevents motor operation with lid open.
