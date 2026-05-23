# Validation — V-Model XT

## Full Qualification Sequence (Medical Device Validation)

```
IQ → OQ → PQ
│     │     │
│     │     └── Proves it works in real use (Performance Qualification)
│     └──────── Proves it works in target environment (Operational Qualification)
└────────────── Proves it's installed correctly (Installation Qualification)
```

## Directory Purpose

| Directory | Content | Key Questions Answered |
|-----------|---------|----------------------|
| `00_InstallationQualification/` | IQ protocols and reports | Was the system installed correctly? Are all components present and configured? |
| `01_OperationalQualification/` | OQ protocols and reports | Does the system operate within specified limits? Do all functions work in the target environment? |
| `02_PerformanceQualification/` | PQ protocols and reports | Does the system perform according to user needs? Are results accurate and reliable under real conditions? |

## IQ Requirements (Installation Qualification)

- [ ] All hardware components delivered and verified against packing list
- [ ] Software version verified
- [ ] Installation procedure documented and followed
- [ ] Electrical safety check performed
- [ ] Environmental conditions verified (temperature, humidity, power)
- [ ] Network connectivity verified (if applicable)
- [ ] Calibrations verified (factory calibration intact)
- [ ] System starts and passes self-test

## OQ Requirements (Operational Qualification)

- [ ] All functions operate within specified parameters
- [ ] Alarms and safety interlocks function correctly
- [ ] Communication interfaces work (LIS, internal bus)
- [ ] Backup and restore functions verified
- [ ] User access control verified
- [ ] Audit trail functions verified
- [ ] Error recovery procedures validated
- [ ] Performance at operational limits verified

## PQ Requirements (Performance Qualification)

- [ ] Complete workflow runs correctly with real samples
- [ ] Results are accurate compared to reference method
- [ ] Throughput meets specification
- [ ] Precision meets specification (within-run, between-run)
- [ ] Carryover is within acceptable limits
- [ ] Interference handling works (hemolysis, icterus, lipemia)
- [ ] QC system functions correctly
- [ ] User acceptance criteria met
- [ ] Intended use verified

## Regulatory Basis

- **IVDR Annex II §6.1**: Technical documentation shall include verification and validation
- **IVDR Annex I §18.6**: Performance evaluation includes analytical and clinical performance
- **ISO 13485 §7.3.7**: Design and development validation
- **IEC 62304 §5.7**: Software system testing
