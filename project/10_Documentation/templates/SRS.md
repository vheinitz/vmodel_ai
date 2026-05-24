---
id: DOC-SRS-{COMPONENT}
type: document-cover
document_kind: SRS
component: {COMPONENT}
status: draft
version: v00.01
created: {DATE}
updated: {DATE}
covers_artifacts_in: project/01_Requirements/03_SoftwareReqs/{COMPONENT}/
---

# Software Requirements Specification (SRS) — Cover Document

**Document ID:** {PROJECT_NUMBER}_CD_{COMPONENT}_SRS_v{MAJOR}.{MINOR}  
**Component:** {COMPONENT_NAME} (AC / AD / AF)  
**Project:** {PROJECT_NAME}  
**Version:** v00.01 (Draft)  
**Date:** {DATE}  
**Author:** Requirements Engineer  
**Reviewer:** System Architect  

> **Note on structure (since template v2):** Individual requirements live in their own files
> under `project/01_Requirements/03_SoftwareReqs/{COMPONENT}/REQ-SW-{COMPONENT}-NNN.md`, each
> with YAML frontmatter per `.pi/rules/artifact-frontmatter.md`. This cover document holds
> document-level metadata, scope, definitions, interface summaries and regulatory mapping.
> The per-requirement details in sections 3, 4 and 6 below are kept here as **examples of
> the template** for human readers; the authoritative source is the per-file artifacts.

---

## 1. Introduction

### 1.1 Purpose
This Software Requirements Specification defines the software requirements for the **{COMPONENT_NAME}** component of the {PROJECT_NAME} system.

### 1.2 Scope
{COMPONENT_DESCRIPTION}

### 1.3 Definitions and Acronyms
| Term | Definition |
|------|-----------|
| GUI | GUI Application Component |
| CTRL | Device Control Software Component |
| FW | Embedded Firmware Component |
| CAN | Controller Area Network — internal device communication bus |
| LIS | Laboratory Information System |
| ASTM | ASTM E1381/E1394 — LIS communication protocol |
| SOUP | Software of Unknown Provenance |

### 1.4 References
- System Requirements Specification: `project/01_Requirements/02_SystemReqs/SystemRequirements_SyRS.md`
- ISO 14971 Risk Management File
- IEC 62304:2006+AMD1:2015

## 2. General Description

### 2.1 Product Perspective
{COMPONENT_NAME} is part of the {PROJECT_NAME} laboratory automation system. It interfaces with:
- {INTERFACE_1}
- {INTERFACE_2}

### 2.2 User Characteristics
- Laboratory technicians
- Laboratory managers
- Service engineers
- System administrators

### 2.3 Operating Environment
- Operating System: {OS}
- Database: {DB}
- Hardware: {HARDWARE}

### 2.4 Design and Implementation Constraints
- Programming Language: Project-specific (e.g., C++17, C, Python)
- Framework: Project-specific (e.g., Qt, WPF, React)
- Regulatory: IEC 62304 Safety Class {SAFETY_CLASS}

## 3. Functional Requirements

### 3.1 Requirement Template
Each requirement follows this format:

| Attribute | Description |
|-----------|-------------|
| **ID** | REQ-SW-{COMPONENT}-{NNN} |
| **Type** | Functional / Non-Functional / Safety / Regulatory / Interface |
| **Priority** | Must / Should / Nice-to-Have |
| **Source** | Stakeholder / System Req / Risk Analysis / Regulatory |
| **Description** | Clear, singular requirement statement |
| **Rationale** | Why this requirement exists |
| **Risk Link** | FMEA-ID (if safety-related) |
| **Test Link** | TC-ID |
| **Status** | Proposed / Approved / Implemented / Verified |

---

### 3.2 Requirements List

#### REQ-SW-{COMPONENT}-001: {TITLE}
- **Type:** {TYPE}
- **Priority:** {PRIORITY}
- **Description:** {DESCRIPTION}
- **Rationale:** {RATIONALE}
- **Risk Link:** {FMEA_ID}
- **Test Link:** {TEST_ID}
- **Status:** Proposed

<!-- Repeat for each requirement -->

---

## 4. Non-Functional Requirements

### 4.1 Performance Requirements

#### REQ-SW-{COMPONENT}-PERF-001: {TITLE}
- **Description:** {DESCRIPTION}
- **Metric:** {METRIC} (e.g., response time < 200ms)

### 4.2 Reliability Requirements

#### REQ-SW-{COMPONENT}-REL-001: {TITLE}
- **Description:** {DESCRIPTION}

### 4.3 Security Requirements

#### REQ-SW-{COMPONENT}-SEC-001: {TITLE}
- **Description:** {DESCRIPTION}

### 4.4 Usability Requirements

#### REQ-SW-{COMPONENT}-USE-001: {TITLE}
- **Description:** {DESCRIPTION}

## 5. Interface Requirements

### 5.1 External Interfaces
| Interface | Protocol | Specification |
|-----------|----------|---------------|
| LIS Communication | ASTM E1381 | See InterfaceSpec_LIS.md |
| CAN Bus | Proprietary | See InterfaceSpec_CAN.md |

### 5.2 Internal Interfaces
| Interface | Between | Specification |
|-----------|---------|---------------|
| AC ↔ AD | TCP/IP | See API_Specification.md |

## 6. Safety Requirements (IEC 62304)

The following requirements are classified as **safety-related**:

#### REQ-SW-{COMPONENT}-SAF-001: {TITLE}
- **Type:** Safety
- **Priority:** Must
- **Hazard:** {HAZARD_DESCRIPTION}
- **Safety Class:** {SAFETY_CLASS}
- **Description:** {DESCRIPTION}
- **Risk Control:** {RISK_CONTROL_MEASURE}
- **Risk Link:** {FMEA_ID}
- **Test Link:** {TEST_ID}

## 7. Regulatory Requirements

| Regulation | Requirement | Implementation |
|------------|-------------|----------------|
| IEC 62304 §5.2 | Document SW requirements | This document |
| IEC 62304 §5.2 | Identify safety requirements | Section 6 |
| ISO 14971 §7.2 | Link requirements to risk controls | Risk Link attribute |
| IVDR Annex II §6.1 | Technical documentation | Traceability matrix |

## 8. Traceability

Refer to the project traceability matrix:
- `10_Documentation/TraceabilityMatrix.md`

## 9. Document History

| Version | Date | Author | Changes |
|---------|------|--------|---------|
| v00.01 | {DATE} | {AUTHOR} | Initial draft |

---

*Template version: 1.0 | IEC 62304 §5.2 compliant*
