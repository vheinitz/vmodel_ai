---
id: COMP-005
type: architecture-component
layer: software
status: draft
realizes: [REQ-SYS-010]
interfaces: [IF-MOTOR]
created: 2026-05-26
updated: 2026-05-26
---

# COMP-005: Motor Controller (Firmware Module)

## Layer
Software (Firmware — part of COMP-001 Central Control Unit)

## Responsibility
Generates PWM signals to control the DC motor speed. Implements soft-start ramp-up to reduce mechanical stress, maintains target speed via PID control using tachometer feedback, monitors motor current for stall detection, and performs controlled deceleration on stop command.

## Safety Class
B — incorrect motor speed → non-uniform mixing → wrong diagnostic result

## Key Functions
- **Speed Control**: PID loop with tachometer feedback maintaining target RPM ±5%
- **Soft-Start**: Linear ramp from 0 to target speed over 500 ms to prevent tube dislodging
- **Stall Detection**: Motor current above threshold for > 200 ms → error flag to COMP-008
- **Emergency Braking**: On emergency stop or lid-open, disable motor output immediately; mechanical braking within 1 second per REQ-SYS-050
- **Speed Monitoring**: Continuous comparison of actual vs target speed; deviation > 20% triggers error

## Interface
| Signal | Direction | Description |
|--------|-----------|-------------|
| PWM_OUT | Output → IF-MOTOR | PWM duty cycle controlling motor speed |
| DIR_OUT | Output → IF-MOTOR | Motor direction (if reversible mixing required) |
| TACH_IN | Input ← IF-MOTOR | Tachometer pulse train for speed measurement |
| CURRENT_IN | Input ← IF-MOTOR | Motor current sense (ADC) for stall detection |
| ENABLE_OUT | Output → IF-MOTOR | Motor enable (hardware-level, gated by safety interlock) |

## Design Pattern
**State Pattern** — motor states: STOPPED, RAMPING_UP, RUNNING, RAMPING_DOWN, ERROR

## Dependencies
- MCU Timer/PWM peripheral
- ADC peripheral for current sensing
- COMP-006 (Safety Monitor) — motor enable is hardware-gated by safety conditions
