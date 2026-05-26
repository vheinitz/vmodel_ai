---
id: COMP-009
type: architecture-component
layer: software
status: draft
realizes: [REQ-SYS-030, REQ-SYS-090]
interfaces: [IF-POWER]
created: 2026-05-26
updated: 2026-05-26
---

# COMP-009: Power Supervisor (Firmware Module)

## Layer
Software (Firmware — part of COMP-001 Central Control Unit)

## Responsibility
Monitors the power supply status, detects brown-out conditions before voltage drops below the microcontroller's minimum operating level, and triggers safe state preservation. Manages non-volatile memory writes for cycle state persistence across power cycles.

## Safety Class
B — failure to preserve state on power loss could result in undetected incomplete mixing

## Key Functions
- **Brown-Out Detection**: Monitor brown-out warning signal from COMP-004 (voltage comparator); when DC rail drops below threshold, interrupt main loop and trigger emergency save
- **Safe Shutdown Sequence**:
  1. Brown-out warning received (≥ 5 ms before voltage drops below MCU minimum)
  2. Disable motor immediately (stop mixing)
  3. Write current cycle state to non-volatile memory (EEPROM or Flash)
  4. Set brown-out flag in NVM
  5. Enter infinite loop until power fully lost or restored
- **Power-On Recovery Check**: On boot, read NVM for brown-out flag and saved cycle state; forward to COMP-008
- **NVM Wear Management**: Use wear-leveled storage for frequently-written cycle state; minimum 100,000 write cycles endurance
- **Hold-Up Verification**: On production test, verify that the power supply hold-up time exceeds the worst-case NVM write time (typically ≥ 50 ms hold-up for ≤ 10 ms write)

## Interface
| Signal | Direction | Description |
|--------|-----------|-------------|
| BROWN_OUT_IN | Input ← COMP-004 | Brown-out warning (GPIO interrupt, highest priority) |
| POWER_GOOD_IN | Input ← COMP-004 | Power rail within spec |
| POWER_STATE_OUT | Output → COMP-008 | Current power status (normal / warning / lost) |
| NVM_STATE_RW | Bidirectional | Read/write cycle state to EEPROM/Flash |

## Design Pattern
**Observer Pattern** — monitors power supply and publishes status; highest-priority interrupt handler for brown-out

## Dependencies
- MCU NMI (non-maskable interrupt) or highest-priority GPIO interrupt for brown-out signal
- EEPROM or Flash memory with sufficient write endurance
