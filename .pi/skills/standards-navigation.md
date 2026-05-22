# Skill: Medical Device Standards Navigation

## Purpose
This skill enables any agent to understand and apply the relevant standards for medical device software and laboratory automation devices. It provides a navigable index of norms, what each covers, and how to apply them in the project context.

## Standards Inventory (from project literature)

### Core Software & Risk Standards

| Standard | Full Title | Application |
|----------|-----------|-------------|
| **DIN EN 62304** | Medical Device Software — Software Lifecycle Processes | **PRIMARY** — governs all software development activities |
| **DIN EN ISO 14971** | Application of Risk Management to Medical Devices | **PRIMARY** — governs all risk management |
| **DIN EN ISO 13485** | Medical Devices — Quality Management Systems | QMS requirements for the organization |
| **IEC 81001-5-1:2021** | Health Software — Security by Design | Cybersecurity for health software |
| **DIN EN 62366-1** | Medical Devices — Usability Engineering | Usability requirements for medical devices |
| **DIN EN 60601-1** | Medical Electrical Equipment — General Safety | Electrical safety for lab devices |
| **DIN EN 61010** | Safety Requirements for Electrical Equipment for Measurement, Control, and Laboratory Use | Lab equipment safety |

### Analysis & Process Standards

| Standard | Application |
|----------|------------|
| **DIN EN 60812** | Failure Mode and Effects Analysis (FMEA) — Procedure |
| **DIN EN 60300-3-4** | Dependability Management — Guide to specification of dependability requirements |
| **DIN EN 13972** | Sterilization of medical devices — (if applicable to sample handling) |
| **DIN EN 13641:2002** | Elimination or reduction of risk of infection related to in-vitro diagnostic reagents |

### Regulatory Guidance

| Document | Source | Application |
|----------|--------|-------------|
| **IVDR (EU) 2017/746** | European Union | In-vitro diagnostic regulation |
| **MDCG 2019-16** | EU Commission | Cybersecurity for medical devices |
| **MDCG 2022-8** | EU Commission | Clinical evaluation / performance evaluation |
| **MDCG 2022-9** | EU Commission | Summary of safety and performance |
| **MDCG 2022-10** | EU Commission | Transitional provisions IVDR |
| **MDCG 2019-11** | EU Commission | Qualification and classification of software |

### Communication Standards (Lab Context)

| Standard | Application |
|----------|------------|
| **ASTM E1381/E1394** | LIS communication protocol (low-level + high-level) |
| **HL7 v2.x** | Health Level 7 messaging (order/results) |
| **IHE Laboratory Technical Framework** | Integrating the Healthcare Enterprise — lab profiles |

### EMC and Environmental

| Standard | Application |
|----------|------------|
| **DIN EN 61326** | EMC for laboratory equipment |
| **EMV Richtlinie 2014/30/EU** | Electromagnetic Compatibility Directive |
| **RoHS 2011/65/EU** | Restriction of Hazardous Substances |

---

## How Agents Use This Skill

### Requirements Engineer
When creating requirements, consult:
- **DIN EN 62304 §5.2**: What must requirements contain for medical device SW?
- **IEC 81001-5-1**: Security requirements for health software
- **DIN EN 62366-1**: Usability requirements
- **IVDR Annex I**: General Safety and Performance Requirements (GSPR)

### System Architect
When designing architecture, consult:
- **DIN EN 62304 §5.3**: Software architectural design requirements
- **DIN EN 60601-1**: Electrical safety → impacts hardware/software boundary
- **DIN EN 61010**: Lab equipment safety → operational constraints

### Risk Manager
When conducting risk analysis, consult:
- **DIN EN ISO 14971**: Complete risk management process
- **DIN EN 60812**: FMEA procedure
- **IEC 60812**: FMEA standard procedure reference

### Tester
When designing tests, consult:
- **DIN EN 62304 §5.5-5.7**: Test requirements per software safety class
- **DIN EN 62366-1**: Usability test requirements

### QA Manager
When auditing, consult:
- **DIN EN ISO 13485**: QMS audit criteria
- **DIN EN 62304**: All clauses for process compliance checklist

---

## Standard-Specific Quick Reference

### DIN EN 62304 — Software Lifecycle Checklist
- [ ] §4.3: Software safety class determined
- [ ] §5.1: Software development plan documented
- [ ] §5.2: Software requirements documented and verified
- [ ] §5.3: Software architecture documented and verified
- [ ] §5.4: Detailed design (Class B/C) documented and verified
- [ ] §5.5: Units implemented and verified
- [ ] §5.6: Integration tested
- [ ] §5.7: System tested
- [ ] §5.8: Release documented
- [ ] §6: Maintenance process defined
- [ ] §7: Risk management integrated
- [ ] §8: Configuration management established
- [ ] §9: Problem resolution process defined

### IVDR Annex I — GSPR Checklist (Software Relevant)
- [ ] Devices shall achieve the performance intended by the manufacturer
- [ ] Safety and performance shall not be compromised during lifetime
- [ ] Devices shall be designed to reduce risks as far as possible
- [ ] Risk control measures shall not adversely affect benefit-risk ratio
- [ ] Devices shall be protected against unauthorized access (IT security)
- [ ] Software shall be developed per state-of-the-art (→ IEC 62304)
- [ ] Devices shall be designed for ease of use (→ IEC 62366-1)
- [ ] Measurement accuracy, precision, and traceability shall be specified
- [ ] Instructions for use shall be clear and understandable

### IEC 81001-5-1 — Security by Design Checklist
- [ ] Security risk assessment completed
- [ ] Secure coding standards defined
- [ ] Authentication and access control implemented
- [ ] Data encryption for sensitive data (patient data at rest + in transit)
- [ ] Secure software updates (signed, verified)
- [ ] Audit logging of security-relevant events
- [ ] Vulnerability management process
- [ ] Security testing integrated into development lifecycle

---

## Standard Hierarchy (Which Takes Precedence)

```
1. EU Regulations (MDR / IVDR) — legally binding
2. Harmonized Standards (DIN EN ISO 14971, DIN EN 62304, etc.)
3. MDCG Guidance Documents
4. Non-harmonized standards (ISO technical reports)
5. Internal SOPs and guidelines
```

---

## Document Lookup Pattern

When an agent needs to verify compliance with a specific standard clause:
1. Check `09_Regulatory/` for project-specific compliance matrices
2. Reference this skill for standard clause summaries
3. Compare project artifacts against clause checklists above
4. Flag gaps as non-conformances (→ QA Manager)
