---
id: FMEA-006
type: fmea-entry
status: draft
hazard: Cross-contamination between patient samples due to inadequate cleaning
hazardous_situation: Biological residue from Sample A remains on device surfaces after cleaning. When Sample B is processed, residue transfers into Sample B or the next sample's container exterior. Sample B's diagnostic result is contaminated with material from Sample A.
harm: Incorrect diagnostic result for Sample B — either false positive (detecting analyte from Sample A) or false negative (dilution effect). Leads to wrong clinical decision: missed diagnosis or unnecessary treatment.
severity: 7
probability: 4
detection: 6
rpn: 168
controls: [REQ-SYS-060]
residual_severity: 7
residual_probability: 4
residual_acceptable: false
related_requirements: [REQ-SYS-060]
tests: []
created: 2026-05-26
updated: 2026-05-26
approver: Risk Manager
---

# FMEA-006: Cross-Contamination Between Samples

## Function
Easy cleaning and cross-contamination prevention (STK-005)

## Failure Mode
Residual biological material from a previous sample contaminates the next sample processed in the device.

## Cause
- Device surfaces difficult to reach and clean (crevices, seams, threads)
- Cleaning procedure too time-consuming → staff skip or shorten it
- Cleaning agent incompatible with device surface → surface degrades, becomes harder to clean
- Porous or rough surfaces trap biological material
- Drip tray or internal chamber not emptied/cleaned between runs
- Aerosol deposition inside chamber after mixing
- Staff not trained on correct cleaning procedure

## Effect
- Carryover of analyte from previous sample to next sample
- False positive result for next patient (analyte detected that is not theirs)
- Potential false negative if carryover causes dilution or interference
- Wrong clinical decision — unnecessary treatment or missed diagnosis
- Loss of confidence in lab results

## Risk Control (Proposed)
1. **Design**: Smooth, non-porous, chemical-resistant surfaces (stainless steel or medical-grade polymer); no crevices, seams, or threaded connections in sample-contact area; drip tray removable without tools for separate cleaning/disinfection; rounded internal corners (no sharp angles where residue accumulates)
2. **Protective**: Removable, autoclavable sample-contact components; visual inspection window to verify cleanliness before next run
3. **Information**: Validated cleaning SOP in user manual; list of approved cleaning agents; training on correct cleaning procedure

## Verification
- Carryover test: process high-concentration sample, clean per SOP, process blank — verify analyte below detection limit
- Surface swab test after cleaning: verify no detectable protein residue
- Compatibility test with approved cleaning agents (no surface degradation after 1000 cleaning cycles)
