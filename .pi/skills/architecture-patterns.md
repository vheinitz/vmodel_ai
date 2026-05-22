# Skill: Software Architecture Patterns — Medical Lab Device Systems

## Purpose
Architecture pattern selection and application guide for medical laboratory automation devices. Based on **O'Reilly "Software Architecture Patterns"** (Mark Richards, 2015) and **GoF Design Patterns**, adapted for medical device constraints (IEC 62304, real-time control, hardware integration).

## Sources
- Richards, M. (2015): *Software Architecture Patterns*, O'Reilly Media
- Gamma, E. et al. (1994): *Design Patterns: Elements of Reusable Object-Oriented Software* (GoF)
- IEC 62304:2006+AMD1:2015 §5.3 — Software Architectural Design

---

## 1. Primary Architecture Pattern: Layered Architecture

### Why Layered for Medical Lab Devices
The **Layered (n-tier) Architecture** is the recommended default pattern for medical lab automation systems because:
- **Separation of concerns** maps naturally to IEC 62304's requirement for segregation of safety-critical components
- **Testability per layer** enables independent verification of GUI, business logic, data access, and communication
- **Regulatory compliance**: Each layer can be documented, reviewed, and verified independently
- **Team organization**: Matches typical organizational structure (UI team, backend team, firmware team)

### Standard Layers for Medical Lab Device

```
┌─────────────────────────────────────────────────────┐
│                 PRESENTATION LAYER                   │
│  GUI Components, Screens, User Input, Visualization  │
│  Safety Class: B (misleading display possible)       │
├─────────────────────────────────────────────────────┤
│                BUSINESS LOGIC LAYER                  │
│  Workflow Engine, Protocol Execution, Calculations   │
│  Safety Class: C (wrong results → patient harm)      │
├─────────────────────────────────────────────────────┤
│                 DATA ACCESS LAYER                    │
│  Database ORM, Repository Pattern, Data Validation   │
│  Safety Class: C (data corruption → wrong results)   │
├─────────────────────────────────────────────────────┤
│               COMMUNICATION LAYER                    │
│  Internal Bus Protocol, External LIS/HIS, Networking │
│  Safety Class: C (communication failure → lost data) │
└─────────────────────────────────────────────────────┘
```

### Layer Isolation Rule (IEC 62304 Compliance)
- Each layer communicates ONLY with the layer directly below
- Safety-critical code is isolated in Business Logic and Data Access layers
- Presentation layer cannot directly access database or communication
- Cross-layer communication uses well-defined interfaces (enables mocking for tests)

---

## 2. Architecture Drawing Rules (per Specification)

### The 5-Artefact Rule
**No architecture drawing may contain more than 5 distinct artefacts** (components, nodes, interfaces). If an architecture has more than 5 components, split it into multiple drawings:

1. **System Context Diagram** (≤5 external actors/systems)
2. **Component Decomposition — Level 1** (≤5 top-level components)
3. **Component Decomposition — Level 2** (≤5 sub-components per component)
4. **Interface Diagram — Internal Bus** (≤5 bus participants)
5. **Interface Diagram — External Systems** (≤5 external interfaces)
6. **Deployment Diagram** (≤5 physical nodes)
7. **Data Flow Diagram — Critical Path** (≤5 processing steps)

### Valid Architecture Drawing Types

| Drawing | Max Artefacts | Content |
|---------|--------------|---------|
| System Context | 5 | External actors/systems around the device |
| Component Overview L1 | 5 | Top-level system components |
| Component Internal L2 | 5 | Sub-components of ONE L1 component |
| Internal Bus Topology | 5 | Devices/controllers on internal bus |
| External Interfaces | 5 | LIS, HIS, Printer, Remote Service, Cloud |
| Deployment | 5 | Physical nodes (PC, embedded boards, instruments) |
| Critical Data Flow | 5 | Processing steps for safety-critical data |

---

## 3. Bus and Connection Architecture

### PC ↔ Firmware Communication Pattern

Medical lab devices typically have a **split architecture**:
- **PC Side**: GUI + Business Logic + Database (high-level control)
- **Firmware Side**: Real-time controllers on embedded boards (low-level control)
- **Connection**: Internal bus (CAN, RS-485, Ethernet, or proprietary)

```
┌──────────────────────┐         ┌──────────────────────┐
│        PC/HMI        │         │   Embedded Controller │
│  ┌────────────────┐  │  BUS   │  ┌────────────────┐   │
│  │ Command Disptch │◄─┼────────┼─►│ Command Handler │   │
│  └────────────────┘  │ (CAN/  │  └────────────────┘   │
│  ┌────────────────┐  │ RS485/ │  ┌────────────────┐   │
│  │ Status Monitor  │◄─┼─Ether)─┼─►│ Status Reporter │   │
│  └────────────────┘  │        │  └────────────────┘   │
│  ┌────────────────┐  │        │  ┌────────────────┐   │
│  │ Telemetry Store │◄─┼────────┼─►│ Sensor Reader   │   │
│  └────────────────┘  │        │  └────────────────┘   │
└──────────────────────┘         └──────────────────────┘
```

### Bus Architecture Principles
- **Command/Response Pattern**: PC sends commands, firmware acknowledges
- **Telemetry Streaming**: Firmware continuously sends sensor data
- **Heartbeat/Watchdog**: Both sides monitor connection health
- **Error Recovery**: Bus disconnect → graceful degradation → reconnection protocol

---

## 4. Key Design Patterns for Medical Device Software

### From GoF Patterns — Medical Device Applications

| Pattern | Application | Safety Relevance |
|---------|------------|-----------------|
| **State** | Workflow engine, protocol execution states | C — wrong state = wrong action |
| **Observer** | Sensor data propagation, UI updates | B — stale display possible |
| **Strategy** | Assay protocol variants, calibration methods | B — wrong algorithm selection |
| **Command** | Bus commands, undo/redo for configuration | C — wrong command sent |
| **Singleton** | Hardware abstraction, device manager | B — must be thread-safe |
| **Factory Method** | Protocol object creation, assay file parsing | A — creation logic only |
| **Decorator** | Result post-processing, unit conversion | C — calculation error |
| **Facade** | Hardware abstraction layer, simplifying complex firmware | B — simplifies but hides |
| **Proxy** | Remote service access, LIS communication | B — network failure handling |

### Anti-Patterns to Avoid (per Richards)

| Anti-Pattern | Risk | Solution |
|-------------|------|----------|
| **Big Ball of Mud** | No architecture, everything coupled | Use layered architecture from start |
| **Architecture by Implication** | "We'll figure it out later" | Document architecture before coding |
| **Golden Hammer** | Same pattern everywhere | Choose pattern per component need |
| **Stovepipe** | Duplicated functionality across components | Shared libraries with defined interfaces |

---

## 5. Architecture Documentation Standards (IEC 62304)

### Required Architecture Views per IEC 62304 §5.3

1. **Functional View**: What does each component do?
2. **Interface View**: How do components communicate?
3. **Data Flow View**: How does data move through the system?
4. **Safety View**: Which components are safety-critical, how are they segregated?
5. **SOUP View**: What third-party software is used?

### Component Specification Template
```markdown
## Component: [Name]
- **ID**: COMP-XXX
- **Layer**: Presentation / Business Logic / Data Access / Communication
- **Safety Class**: A / B / C (per IEC 62304 §4.3)
- **Responsibility**: [Single, clear purpose]
- **Interfaces**:
  - Provides: [interface name] → consumed by [component]
  - Requires: [interface name] ← provided by [component]
- **Dependencies**: [list of SOUP and internal components]
- **Error Handling**: [strategy for this component]
- **Thread Model**: [single-threaded / thread-safe / real-time]
- **State Machine**: [reference to state diagram if applicable]
```
