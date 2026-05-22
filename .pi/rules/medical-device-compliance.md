# Rules: Medical Device Software Compliance

## Applicable Standards

### IEC 62304:2006 + AMD1:2015 — Medical Device Software Lifecycle
The **primary standard** governing software development for medical devices.

**Key Requirements:**
1. **Software Safety Classification** (§4.3): Classify as A, B, or C
2. **Software Development Plan** (§5.1): Document development process
3. **Requirements Analysis** (§5.2): Document all SW requirements
4. **Architectural Design** (§5.3): Transform requirements into architecture
5. **Detailed Design** (§5.4): Detailed design for each SW unit
6. **Unit Implementation & Verification** (§5.5): Code + unit tests
7. **Integration & Integration Testing** (§5.6): Verify SW components work together
8. **System Testing** (§5.7): Verify complete SW system meets requirements
9. **Release** (§5.8): Document release process
10. **Maintenance** (§6): Change management after release
11. **Risk Management** (§7): Integrate with ISO 14971
12. **Configuration Management** (§8): Version control all artifacts
13. **Problem Resolution** (§9): Defect tracking and resolution

**Class-Dependent Requirements:**

| Activity | Class A | Class B | Class C |
|----------|---------|---------|---------|
| Detailed Design | Optional | Required | Required + additional |
| Unit Verification | By implementer | By implementer | Independent reviewer |
| Integration Testing | Optional | Required | Required |
| System Testing | Required | Required | Required + additional |
| SOUP Management | Document | Risk analysis | Risk analysis + monitoring |

### ISO 14971:2019 — Risk Management for Medical Devices
- Risk management throughout lifecycle
- Risk analysis, evaluation, control
- Residual risk acceptance
- Risk management file
- Production and post-production activities

### ISO 13485:2016 — Medical Devices QMS
- Quality management system requirements
- Document control
- Design and development controls
- Purchasing controls
- Production and service controls
- Monitoring and measurement

### IVDR (EU) 2017/746 — In-Vitro Diagnostic Medical Devices Regulation
- Conformity assessment procedures
- Technical documentation requirements
- Post-market surveillance
- Vigilance and market surveillance

## Software Safety Classification (IEC 62304)

### How to Determine Safety Class
1. Identify hazards associated with the medical device
2. Assess severity of harm from each hazard
3. Classify each software item based on worst-case severity:

| Safety Class | If software failure can result in... |
|-------------|--------------------------------------|
| **C** | Death or serious injury (permanent impairment or life-threatening) |
| **B** | Non-serious injury (temporary, reversible) |
| **A** | No hazardous situation (or harm is prevented by hardware) |

### Example Assessment for Lab Automation Devices

| Software Item | Potential Hazard | Typical Safety Class |
|--------------|------------------|---------------------|
| Liquid handling control | Wrong sample volume → incorrect diagnosis | C |
| Result calculation | Wrong result → incorrect clinical decision | C |
| Motor/actuator control | Uncontrolled movement → operator injury | B |
| External system communication | Wrong patient data association → wrong result | C |
| User interface display | Misleading display → wrong interpretation | B |
| Configuration tool | Wrong configuration → assay failure | B |
| Service/diagnostic tool | Diagnostic data exposure → no patient harm | A |

## Mandatory Quality Gates for Medical Device SW

Each phase requires:
- [ ] **Formal Review** — Documented review with independent reviewer
- [ ] **Traceability** — Forward and backward traceability established
- [ ] **Risk Assessment** — Risk controls verified for this phase
- [ ] **Configuration Status** — All items under version control
- [ ] **QA Audit** — Phase audit by QA (for Class B/C)
- [ ] **Sign-off** — Approved by authorized signatory

## Document Retention
- All documents retained for device lifetime + 10 years (IVDR)
- Audit trail of all changes maintained
- Electronic records comply with 21 CFR Part 11 (if applicable)
