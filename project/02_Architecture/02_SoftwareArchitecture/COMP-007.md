---
id: COMP-007
type: architecture-component
layer: software
status: draft
realizes: [REQ-SYS-070, REQ-SYS-080]
interfaces: [IF-UI]
created: 2026-05-26
updated: 2026-05-26
---

# COMP-007: User I/O Manager (Firmware Module)

## Layer
Software (Firmware — part of COMP-001 Central Control Unit)

## Responsibility
Manages all operator-facing inputs and outputs: button debouncing, LED pattern generation, and buzzer control. Translates raw electrical signals into logical events consumed by the Cycle State Machine (COMP-008).

## Safety Class
B — incorrect status indication could cause operator to forward poorly-mixed sample

## Key Functions
- **Button Debouncing**: 50 ms debounce on start and stop button inputs; reject glitches and contact bounce
- **Start Detection**: Rising edge on debounced start signal → START_REQUESTED event to COMP-008; reject if already mixing (per REQ-SYS-070)
- **Stop Detection**: Rising edge on debounced stop signal → STOP_REQUESTED event to COMP-008; 100 ms response time target from press to motor power interruption
- **LED Driver**: PWM control of RGB LED with patterns:
  - Green steady: ready/idle or done
  - Green flashing (1 Hz, 50% duty): mixing in progress
  - Red flashing (2 Hz, 50% duty): error/fault
- **Buzzer Driver**: PWM tone generation for audible alarm; activation on error state; continues until acknowledged or power-off
- **Power-On Lamp Test**: On boot, cycle all LEDs and buzzer briefly (500 ms) for self-test

## Interface
| Signal | Direction | Description |
|--------|-----------|-------------|
| BTN_START_IN | Input ← IF-UI | Start button (active-low with pull-up) |
| BTN_STOP_IN | Input ← IF-UI | Stop button (active-low with pull-up) |
| LED_R_OUT, LED_G_OUT, LED_B_OUT | Output → IF-UI | RGB LED channels (PWM) |
| BUZZER_OUT | Output → IF-UI | Buzzer PWM output |
| EVENT_START | Output → COMP-008 | Debounced start event |
| EVENT_STOP | Output → COMP-008 | Debounced stop event |

## Design Pattern
**Observer Pattern** — publishes debounced button events to subscribers (COMP-008)

## Dependencies
- MCU GPIO with interrupt-on-change for buttons
- MCU Timer/PWM for LED dimming and buzzer tone
