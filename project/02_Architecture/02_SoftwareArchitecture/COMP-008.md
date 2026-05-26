---
id: COMP-008
type: architecture-component
layer: software
status: draft
realizes: [REQ-SYS-090]
interfaces: [IF-MOTOR, IF-UI, IF-SAFETY, IF-POWER]
created: 2026-05-26
updated: 2026-05-26
---

# COMP-008: Mixing Cycle State Machine (Firmware Module)

## Layer
Software (Firmware — part of COMP-001 Central Control Unit)

## Responsibility
Orchestrates the complete mixing cycle from idle through mixing to completion or error. Maintains cycle state in non-volatile memory for power-loss recovery. This is the central coordination module that connects all other software components.

## Safety Class
B — incorrect state management could produce wrong result (incomplete mixing undetected) or safety hazard (mixing with lid open)

## State Machine

```
                    ┌──────────┐
          ┌────────►│   IDLE   │◄─────────┐
          │         └────┬─────┘          │
          │              │ START +        │
          │              │ lid closed     │
          │         ┌────▼─────┐          │
          │         │  MIXING  ├── error ─┤
          │         └────┬─────┘          │
          │     complete  │  stop/estop   │
          │         ┌────▼─────┐     ┌────┴─────┐
          │         │ SETTLING │     │  ERROR   │
          │         │ (3 sec)  │     │ (latched)│
          │         └────┬─────┘     └────┬─────┘
          │              │                │ ack/power-cycle
          │         ┌────▼─────┐          │
          └─────────┤   DONE   │◄─────────┘
                    └──────────┘
```

| State | Description | LED Pattern |
|-------|-------------|-------------|
| IDLE | Ready, waiting for start | Green steady |
| MIXING | Motor running at target speed | Green flashing 1 Hz |
| SETTLING | Motor stopped, lid locked, aerosols settling (3 s) | Green flashing 1 Hz |
| DONE | Cycle complete, lid unlocked | Green steady |
| ERROR | Fault condition (stall, estop, etc.) | Red flashing 2 Hz + buzzer |

### Transitions
- **IDLE → MIXING**: START event AND lid_closed AND not in restart-prevention lockout
- **MIXING → SETTLING**: Mixing timer expired (fixed duration, e.g., 10 seconds) OR STOP event
- **MIXING → ERROR**: Motor stall detected (COMP-005), safety fault (COMP-006), emergency stop
- **SETTLING → DONE**: 3-second timer expired
- **DONE → IDLE**: Operator removes tube (or on next START)
- **ERROR → IDLE**: Operator acknowledges via power-cycle or long-press stop (per REQ-SYS-080)
- **Any state → ERROR**: Lid opens during MIXING or SETTLING

## Power-Loss Recovery
- On entering MIXING state: write `MIXING` to non-volatile memory (EEPROM/Flash)
- On entering DONE or ERROR: clear NVM state
- On boot: if NVM contains `MIXING`, enter INTERRUPTED sub-state (amber LED, distinct pattern per REQ-SYS-090)
- INTERRUPTED → IDLE on operator acknowledgment

## Interface
| Signal | Direction | Description |
|--------|-----------|-------------|
| EVENT_START | Input ← COMP-007 | Debounced start button press |
| EVENT_STOP | Input ← COMP-007 | Debounced stop button press |
| STATE_OUT | Output → COMP-007 | Current state (for LED pattern selection) |
| MOTOR_CMD | Output → COMP-005 | Motor start/stop/speed commands |
| MOTOR_STATUS | Input ← COMP-005 | Motor running, speed OK, stall flag |
| SAFETY_OK | Input ← COMP-006 | Safety conditions satisfied (lid closed, no estop, no fault) |
| POWER_STATE | Input ← COMP-009 | Power status (normal, brown-out warning) |

## Design Pattern
**State Pattern** — explicit state machine with defined transitions, no ambiguous states
