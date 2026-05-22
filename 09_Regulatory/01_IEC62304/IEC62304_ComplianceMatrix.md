# IEC 62304 Compliance Matrix

**Document ID:** {PROJECT_NUMBER}_CD_IEC62304_Compliance_v{MAJOR}.{MINOR}  
**Project:** {PROJECT_NAME}  
**Safety Class:** {SAFETY_CLASS}  

---

## IEC 62304 Clause Mapping

This matrix maps each IEC 62304 requirement to the corresponding project artifact and status.

| IEC 62304 Clause | Requirement | Project Artifact | Status | Evidence |
|-----------------|-------------|-----------------|--------|----------|
| **4.3** | Software Safety Classification | 08_RiskManagement/03_SafetyClassification/ | Pending | Safety classification report |
| **5.1.1** | Software Development Plan | 00_ProjectManagement/01_ProjectPlan/PMP.md | Pending | PMP |
| **5.1.2** | Document development process | PMS + Reference to V-Model XT | Pending | PMP Section 1.3 |
| **5.1.3** | Document standards, methods, tools | PMP + CM Plan | Pending | PMP, CM_Plan |
| **5.1.4** | Software config management | 00_ProjectManagement/04_ConfigurationManagement/CM_Plan.md | Pending | CM Plan |
| **5.1.5** | Documentation of deliverables | 10_Documentation/DocumentIndex.md | Pending | Document Index |
| **5.2.1** | Define and document SW requirements | 01_Requirements/03_SoftwareReqs/SRS.md | Pending | SRS |
| **5.2.2** | SW requirements content | SRS (includes all required content) | Pending | SRS |
| **5.2.3** | Include risk control measures | SRS Section 6 (Safety Requirements) | Pending | SRS |
| **5.2.4** | Re-evaluate medical device risk | 08_RiskManagement/02_FMEA/ | Pending | FMEA |
| **5.2.5** | Update requirements from risk analysis | Trace from FMEA to SRS | Pending | Requirements Trace Matrix |
| **5.2.6** | Verify requirements | Requirements review checklist | Pending | Review records |
| **5.3.1** | Transform requirements into architecture | 02_Architecture/02_SoftwareArchitecture/ | Pending | SW-SAD |
| **5.3.2** | Develop architecture | SW-SAD | Pending | SW-SAD |
| **5.3.3** | Identify SOUP components | SW-SAD Section 7 | Pending | SW-SAD §7 |
| **5.3.4** | Segregation for risk control | SW-SAD Section 6 | Pending | SW-SAD §6 |
| **5.3.5** | Verify architecture | Architecture review checklist | Pending | Review records |
| **5.4.1** | Detailed design (Class B/C) | 03_Design/02_SoftwareDesign/SDD.md | Pending | SDD |
| **5.4.2** | Interface design | SDD + Interface Specifications | Pending | SDD + Interface Specs |
| **5.4.3** | Verify detailed design | Design review checklist | Pending | Review records |
| **5.5.1** | Implement software units | 04_Implementation/src/ | Pending | Source code |
| **5.5.2** | Establish unit verification process | Test Plan | Pending | Test Plan §2 |
| **5.5.3** | Additional unit acceptance (Class C) | If Class C: additional verification | N/A | — |
| **5.5.4** | Conduct unit verification | 04_Implementation/01_UnitTests/ | Pending | Unit test results |
| **5.5.5** | Document unit verification | 06_Verification/01_UnitTests/ | Pending | Test reports |
| **5.6.1** | Integrate software units | 05_Integration/01_SoftwareIntegration/ | Pending | Integration plan |
| **5.6.2** | Integration testing | 06_Verification/02_IntegrationTests/ | Pending | Integration test results |
| **5.6.3** | Document integration testing | Test Report Section 2 | Pending | Test report |
| **5.6.4** | Regression testing | Test Plan Section 6 | Pending | Regression test results |
| **5.7.1** | SW system testing | 06_Verification/03_SystemTests/ | Pending | System test results |
| **5.7.2** | Document system testing | Test Report Section 3 | Pending | Test report |
| **5.8.1** | Software release | Release procedure in CM Plan | Pending | Release record |
| **5.8.2** | Document released version | CM Plan + Release notes | Pending | Release notes |
| **5.8.3** | Archive software | 99_Archive/ | Pending | Archive |
| **5.8.4** | Ensure delivery reproducibility | CM Plan | Pending | Build reproducibility |
| **5.8.5** | Verify release procedures | QA audit | Pending | Audit report |
| **6.1** | Maintenance plan | 00_ProjectManagement/01_ProjectPlan/ | Pending | Maintenance section |
| **6.2** | Problem and modification analysis | Change control + CAPA | Pending | CR/CAPA records |
| **6.3** | Modification implementation | Change control process | Pending | Change records |
| **7** | Risk management integration | 08_RiskManagement/ | Pending | Risk management file |
| **8** | Configuration management | 00_ProjectManagement/04_ConfigurationManagement/ | Pending | CM Plan + logs |
| **9** | Problem resolution | Defect tracking + CAPA | Pending | Defect log |

---

## Compliance Status Summary

| Clause Group | Total Clauses | Compliant | Partial | Non-Compliant | N/A |
|-------------|--------------|-----------|---------|---------------|-----|
| §4 General Requirements | 1 | 0 | 0 | 0 | 0 |
| §5 Software Development | 24 | 0 | 0 | 0 | 0 |
| §6 Software Maintenance | 3 | 0 | 0 | 0 | 0 |
| §7 Software Risk Management | 1 | 0 | 0 | 0 | 0 |
| §8 Software Configuration | 1 | 0 | 0 | 0 | 0 |
| §9 Software Problem Resolution | 1 | 0 | 0 | 0 | 0 |

---

*Update after each phase completion to track regulatory compliance status.*
