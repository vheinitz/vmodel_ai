---
id: COMP-001
type: architecture-component
layer: system
status: draft
realizes: [REQ-SYS-010, REQ-SYS-020, REQ-SYS-030, REQ-SYS-040, REQ-SYS-050, REQ-SYS-060, REQ-SYS-070, REQ-SYS-080, REQ-SYS-090]
interfaces: [IF-MOTOR, IF-SAFETY, IF-UI, IF-POWER]
created: 2026-05-26
updated: 2026-05-26
---

# COMP-001: Central Control Unit (CCU)

## Layer
System

## Responsibility
The Central Control Unit is the single embedded controller that executes all device logic. It reads sensor inputs (lid interlock, emergency stop, buttons), drives actuators (DC motor, status LEDs, buzzer), manages the mixing cycle state machine, and handles power-loss detection with non-volatile state storage.

## Safety Class
B (IEC 62304) — malfunction could produce non-homogeneous sample → wrong diagnostic result

## Sub-Components (Software)
- COMP-005: Motor Controller
- COMP-006: Safety Monitor
- COMP-007: User I/O Manager
- COMP-008: Mixing Cycle State Machine
- COMP-009: Power Supervisor

## Interfaces

| Interface | Direction | Connected To | Description |
|-----------|-----------|-------------|-------------|
| IF-MOTOR | Output | COMP-002 (Mixing Assembly) | PWM motor speed control, direction, enable |
| IF-SAFETY | Input | COMP-003 (Safety & UI) | Lid interlock status, emergency stop signal |
| IF-UI | Input/Output | COMP-003 (Safety & UI) | Button inputs, LED outputs, buzzer |
| IF-POWER | Input | COMP-004 (Power Supply) | Regulated DC input, brown-out warning signal |

## Deployment
Single PCB with microcontroller (e.g., STM32 or ATmega family), mounted inside the device enclosure. All peripherals connected via board-level wiring.

## Error Handling
- Watchdog timer reset on firmware hang
- Motor stall detection via current sensing
- All outputs default to safe state (motor off) on reset or fault
