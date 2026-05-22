# Common Risks Catalog — Medical Laboratory Automation Devices

## Purpose
This catalog provides a **starting point** for hazard identification when analyzing requirements for medical laboratory automation devices. The Requirements Engineer agent uses this as a reference to identify hazards associated with each requirement.

**Not exhaustive** — always analyze project-specific requirements for additional hazards.

---

## 1. Patient Safety Hazards (Direct Clinical Impact)

### 1.1 Wrong Patient-Sample Association
| Hazard ID | Hazard | Hazardous Situation | Potential Harm |
|-----------|--------|---------------------|---------------|
| H-PAT-001 | Sample ID mismatch | Wrong barcode read → wrong patient linked | Wrong diagnosis, wrong treatment, delayed treatment |
| H-PAT-002 | Sample swap during processing | Rack position tracking error | Patient A gets Patient B's result |
| H-PAT-003 | Duplicate sample registration | Same sample processed twice under different IDs | Conflicting results, unnecessary retesting |
| H-PAT-004 | Lost sample tracking | Sample position lost after error recovery | Result not associated with any patient |
| H-PAT-005 | Patient demographics corruption | LIS communication error corrupts patient data | Result assigned to wrong patient record |

### 1.2 Incorrect Test Results
| Hazard ID | Hazard | Hazardous Situation | Potential Harm |
|-----------|--------|---------------------|---------------|
| H-RES-001 | Wrong result calculation | Algorithm error, wrong formula, unit conversion error | Wrong clinical decision |
| H-RES-002 | Calibration error | Calibration curve drift, expired calibrator | Systematic error across all results |
| H-RES-003 | Wrong reagent identification | Reagent barcode misread → wrong protocol parameters | Invalid result for the intended analyte |
| H-RES-004 | Dilution error | Wrong dilution factor applied | Result off by factor, missed or false positive |
| H-RES-005 | Incorrect reference ranges | Wrong reference range for patient demographics | False normal/abnormal classification |
| H-RES-006 | Interference not detected | Hemolysis, icterus, lipemia not flagged | Clinically incorrect result reported as valid |
| H-RES-007 | QC rule violation ignored | Quality control out of range but results still released | Unreliable results reported |
| H-RES-008 | Result unit confusion | mg/dL vs mmol/L mismatch | Clinically significant misinterpretation |
| H-RES-009 | Decimal point / rounding error | Wrong precision in result display | Dose calculation error from imprecise result |
| H-RES-010 | Result from wrong test protocol | Protocol selection error → result for wrong analyte | Wrong clinical decision |

### 1.3 Delayed or Missing Results
| Hazard ID | Hazard | Hazardous Situation | Potential Harm |
|-----------|--------|---------------------|---------------|
| H-DEL-001 | Critical result not prioritized | STAT sample processed after routine samples | Delayed emergency treatment |
| H-DEL-002 | Result transmission failure | LIS/HIS connection lost → result not sent | Clinical decision delayed |
| H-DEL-003 | System crash during processing | Power loss or software crash → results lost | No result available for clinical decision |
| H-DEL-004 | Throughput bottleneck | System too slow for workload → results delayed | Delayed treatment decisions |

---

## 2. Operator Safety Hazards

### 2.1 Mechanical Hazards
| Hazard ID | Hazard | Hazardous Situation | Potential Harm |
|-----------|--------|---------------------|---------------|
| H-MEC-001 | Moving robotic arm | Operator reaches into working area during operation | Crush injury, pinch injury, fracture |
| H-MEC-002 | Conveyor/drawer movement | Hands caught in moving drawer mechanism | Pinch injury, laceration |
| H-MEC-003 | Centrifuge imbalance | Unbalanced rotor at high speed | Equipment damage, projectile hazard |
| H-MEC-004 | Sharp components | Sample probe, needle, glass fragments | Puncture wound, laceration |
| H-MEC-005 | Falling heavy components | Improperly secured module during maintenance | Crush injury |
| H-MEC-006 | Lid/door closure | Automatic lid closing on operator's hand | Pinch injury |

### 2.2 Biohazard Exposure
| Hazard ID | Hazard | Hazardous Situation | Potential Harm |
|-----------|--------|---------------------|---------------|
| H-BIO-001 | Sample spill | Tube break, overflow, pipetting error | Exposure to infectious material |
| H-BIO-002 | Aerosol generation | Pipetting, mixing, uncapping generates aerosols | Respiratory exposure to pathogens |
| H-BIO-003 | Waste container overflow | Solid/liquid waste not properly contained | Biohazard exposure, contamination |
| H-BIO-004 | Contaminated surfaces | Sample contact with device surfaces | Cross-contamination, exposure during cleaning |
| H-BIO-005 | Sharps injury | Broken glass, sample probe needle | Infection via bloodborne pathogens |

### 2.3 Electrical Hazards
| Hazard ID | Hazard | Hazardous Situation | Potential Harm |
|-----------|--------|---------------------|---------------|
| H-ELE-001 | Electric shock | Exposed wiring, improper grounding, liquid ingress | Electric shock, cardiac effects |
| H-ELE-002 | Fire from short circuit | Overloaded circuit, component failure | Burns, smoke inhalation |
| H-ELE-003 | EMI interference | Device affects other medical equipment | Malfunction of adjacent devices |

### 2.4 Chemical Hazards
| Hazard ID | Hazard | Hazardous Situation | Potential Harm |
|-----------|--------|---------------------|---------------|
| H-CHE-001 | Reagent exposure | Reagent spill, leak, vapor | Chemical burn, respiratory irritation, allergic reaction |
| H-CHE-002 | Cleaning agent exposure | Maintenance with aggressive cleaning agents | Chemical burn, inhalation hazard |
| H-CHE-003 | Reagent mixing | Incompatible reagents mixed by error | Toxic gas release, exothermic reaction |

---

## 3. Data Integrity Hazards

### 3.1 Data Loss / Corruption
| Hazard ID | Hazard | Hazardous Situation | Potential Harm |
|-----------|--------|---------------------|---------------|
| H-DAT-001 | Database corruption | Storage failure, software bug | Loss of all patient results |
| H-DAT-002 | Backup failure | Backup not performed or backup corrupted | Irrecoverable data loss after failure |
| H-DAT-003 | Time synchronization error | Wrong timestamp on result | Wrong temporal context for clinical decision |
| H-DAT-004 | Audit trail failure | Audit log not written, tampered, or incomplete | Regulatory non-compliance, unable to trace errors |
| H-DAT-005 | Configuration data corruption | Device settings corrupted | Wrong operation parameters |
| H-DAT-006 | Race condition in data write | Concurrent access corrupts data | Inconsistent database state |

### 3.2 Unauthorized Access
| Hazard ID | Hazard | Hazardous Situation | Potential Harm |
|-----------|--------|---------------------|---------------|
| H-SEC-001 | Unauthorized data access | Weak authentication, no access control | Patient data breach (GDPR/HIPAA violation) |
| H-SEC-002 | Unauthorized configuration change | No role-based access control | Malicious or accidental misconfiguration |
| H-SEC-003 | Network vulnerability | Unpatched system on network | Remote exploitation, ransomware |
| H-SEC-004 | Audit log tampering | Insufficient access control on audit trail | Cover-up of malicious activity |
| H-SEC-005 | Firmware tampering | Unsigned firmware update possible | Malicious firmware installed |

---

## 4. Software/System Failure Hazards

### 4.1 Software Errors
| Hazard ID | Hazard | Hazardous Situation | Potential Harm |
|-----------|--------|---------------------|---------------|
| H-SW-001 | Unhandled exception/ crash | Software terminates unexpectedly during run | Incomplete processing, data loss, device stops |
| H-SW-002 | Deadlock / livelock | Thread/process deadlock halts system | System unresponsive, workflow stopped |
| H-SW-003 | Memory leak | Gradual memory consumption | System degradation, eventual crash |
| H-SW-004 | Stack overflow | Infinite recursion, too-deep call chain | Crash, unpredictable behavior |
| H-SW-005 | Race condition | Unsynchronized access to shared state | Wrong result, inconsistent state |
| H-SW-006 | Integer overflow / underflow | Calculation exceeds type limits | Wrong result, wrong motor position |
| H-SW-007 | Buffer overflow | Unbounded input written to fixed buffer | Crash, potential security vulnerability |
| H-SW-008 | Timing error | Real-time deadline missed | Missed motor step, wrong liquid volume |
| H-SW-009 | Wrong state transition | Invalid state change in workflow engine | Protocol execution error |
| H-SW-010 | SOUP failure | Third-party library has bug or vulnerability | Dependent functionality fails |

### 4.2 Communication Failures
| Hazard ID | Hazard | Hazardous Situation | Potential Harm |
|-----------|--------|---------------------|---------------|
| H-COM-001 | Internal bus failure | CAN/RS485/... bus disconnected or noisy | Control commands lost, device stops |
| H-COM-002 | LIS/HIS communication failure | Network down, protocol error | Results not transmitted to LIS |
| H-COM-003 | Command/response mismatch | Wrong response to command due to timing | Wrong action executed |
| H-COM-004 | Message corruption | Bit errors in transmission (no CRC or CRC fails) | Wrong data interpreted by receiver |
| H-COM-005 | Communication timeout | No response within required time | System hangs waiting, workflow blocked |

### 4.3 Hardware-Software Interface
| Hazard ID | Hazard | Hazardous Situation | Potential Harm |
|-----------|--------|---------------------|---------------|
| H-HW-001 | Sensor failure | Sensor returns wrong value or no value | Wrong control decision |
| H-HW-002 | Actuator stall | Motor cannot move, overcurrent | Mechanical damage, incomplete action |
| H-HW-003 | Watchdog not triggered | Software hangs but watchdog not configured | System freeze without recovery |
| H-HW-004 | Power fluctuation | Brown-out, voltage dip | Unpredictable behavior, data corruption |
| H-HW-005 | Temperature out of range | Electronics overheating | Component failure, inaccurate measurements |
| H-HW-006 | EEPROM/Flash wear | Excessive writes to non-volatile memory | Configuration loss |

---

## 5. Use Error Hazards (Reasonably Foreseeable Misuse)

| Hazard ID | Hazard | Hazardous Situation | Potential Harm |
|-----------|--------|---------------------|---------------|
| H-USE-001 | Wrong reagent loaded | Reagent vial placed in wrong position | Wrong test protocol executed |
| H-USE-002 | Expired reagent used | Reagent beyond expiry date loaded | Invalid results |
| H-USE-003 | Wrong sample tube type | Incompatible tube used | Sample processing error, wrong volume |
| H-USE-004 | Sample tube insufficiently filled | Dead volume too low | Probe cannot aspirate, air aspiration |
| H-USE-005 | Wrong protocol selected | User selects wrong test from menu | Wrong analysis on sample |
| H-USE-006 | STAT handling error | STAT sample not marked or wrong priority | Delayed critical result |
| H-USE-007 | Maintenance skipped | Required maintenance procedure omitted | System degradation, failure |
| H-USE-008 | Cleaning procedure error | Wrong cleaning agent, incomplete cleaning | Contamination, reagent carryover |
| H-USE-009 | Calibration skipped | Required calibration not performed | Systematic error in results |
| H-USE-010 | Waste not emptied | Waste container full, not replaced | Overflow, contamination |
| H-USE-011 | Unauthorized service access | Non-service personnel opens covers | Injury, equipment damage |
| H-USE-012 | Wrong firmware version | Incompatible firmware installed | Device malfunction |

---

## 6. Environmental Hazards

| Hazard ID | Hazard | Hazardous Situation | Potential Harm |
|-----------|--------|---------------------|---------------|
| H-ENV-001 | Temperature out of spec | Lab temperature too high/low | Reagent degradation, inaccurate photometry |
| H-ENV-002 | Humidity out of spec | High humidity, condensation | Electronics corrosion, short circuits |
| H-ENV-003 | Dust/particulate ingress | Dust on optical components | Photometric error |
| H-ENV-004 | Vibration | External vibration source | Liquid handling inaccuracy, optical noise |
| H-ENV-005 | Power quality | Unstable mains power, surges | Electronics damage, reboot during run |
| H-ENV-006 | Electromagnetic interference | Nearby equipment generates EMI | Sensor reading errors, communication errors |
| H-ENV-007 | Light exposure | Direct sunlight on photometer/optical sensors | Measurement error |

---

## 7. Mapping Requirements to Hazards

### How the RE Agent Uses This Catalog

For each requirement being analyzed:

1. **Category match**: Determine which category the requirement falls under
2. **Hazard scan**: Check each hazard in that category — could this requirement's failure trigger it?
3. **Cross-reference**: Some requirements may trigger hazards across multiple categories
4. **Custom hazards**: Add project-specific hazards not in this catalog
5. **Document**: Create FMEA entry linking REQ-ID → HAZ-ID → Risk Control → Test Case

### Example Derivation

```
Requirement: REQ-SW-CTRL-042 — "The system shall aspirate exactly the volume 
specified in the protocol parameters, with an accuracy of ±2%."

Hazard Analysis:
├── H-HW-001: Sensor failure → wrong volume aspirated
│   Risk Control: Volume verification via pressure/flow sensor
│   Test: TC-UNIT-042a
├── H-SW-006: Integer overflow in volume calculation
│   Risk Control: Range-checked arithmetic, unit-safe types
│   Test: TC-UNIT-042b
├── H-USE-004: Insufficient sample → air aspirated instead of liquid
│   Risk Control: Liquid level detection, clot detection
│   Test: TC-SYS-042c
├── H-MEC-001: Probe crashes into tube bottom
│   Risk Control: Capacitive liquid level detection, force limit
│   Test: TC-SYS-042d
└── FMEA entries created: FMEA-042a, FMEA-042b, FMEA-042c, FMEA-042d
```
