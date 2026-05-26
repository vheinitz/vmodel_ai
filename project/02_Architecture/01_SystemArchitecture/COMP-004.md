---
id: COMP-004
type: architecture-component
layer: system
status: draft
realizes: [REQ-SYS-030]
interfaces: [IF-POWER]
created: 2026-05-26
updated: 2026-05-26
---

# COMP-004: Power Supply Unit

## Layer
System (Electrical)

## Responsibility
The Power Supply Unit converts mains AC power to regulated low-voltage DC for the control electronics and motor. It provides overcurrent protection, EMI filtering, and IEC 61010-1 compliant isolation between mains and accessible parts.

## Safety Class
B — electrical shock hazard to operator; power loss during mixing could produce wrong result

## Sub-Components
- **Mains Inlet**: IEC C14 socket with integrated fuse holder and power switch
- **AC/DC Converter**: Enclosed module (e.g., Mean Well IRM series) providing regulated DC output (e.g., 12V or 24V)
- **Overcurrent Protection**: Primary fuse in mains inlet + secondary polyfuse on DC output
- **Brown-Out Detection**: Voltage comparator generating warning signal to CCU when DC rail drops below threshold
- **EMI Filter**: Integrated in AC/DC converter per IEC 61326-1 (EMC for lab equipment)

## Interfaces

| Interface | Direction | Connected To | Description |
|-----------|-----------|-------------|-------------|
| IF-POWER | Output | COMP-001 (CCU) | Regulated DC voltage rail + brown-out warning signal + power-good signal |

## Key Design Constraints
- Double/reinforced insulation (Class II) per IEC 61010-1 unless protective earth provided
- Leakage current ≤ 0.5 mA (Class II)
- IPX4 protection for electronics enclosure (spill resistance per REQ-SYS-030)
- Hold-up time sufficient for CCU to detect brown-out and save cycle state (≥ 50 ms at full load)
