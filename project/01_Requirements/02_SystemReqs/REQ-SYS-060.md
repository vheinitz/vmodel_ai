---
id: REQ-SYS-060
type: system-requirement
status: draft
priority: must
category: functional
source: [STK-005]
rationale: Cross-contamination between patient samples can produce false diagnostic results. Device surfaces that contact or are exposed to sample material must be designed for effective cleaning with standard lab disinfectants.
verification_method: test
risks: [FMEA-006]
tests: []
created: 2026-05-26
updated: 2026-05-26
approver: Lab Director
---

# REQ-SYS-060: Cleanability and Cross-Contamination Prevention

## Requirement

1. **Surface Design:** All surfaces potentially exposed to sample material or aerosols shall be smooth (Ra ≤ 0.8 µm), non-porous, and free of crevices, seams, threads, or sharp internal corners that could trap biological residue.
2. **Chemical Resistance:** All sample-contact surfaces shall withstand repeated exposure to standard laboratory disinfectants (70% ethanol, 0.5% sodium hypochlorite solution, quaternary ammonium compounds) without degradation, pitting, or discoloration after a minimum of 1000 cleaning cycles.
3. **Accessibility:** All sample-contact surfaces shall be accessible for cleaning without tools. The mixing chamber interior and any drip tray shall be reachable by hand or with a standard laboratory wipe.
4. **Carryover Limit:** After cleaning per the validated SOP, analyte carryover from a high-concentration sample (≥ 100× upper reference limit) to a subsequent blank sample shall be below the lower detection limit of a standard clinical chemistry analyzer.
5. **Cleaning Time:** The complete cleaning procedure between samples shall be executable in ≤ 2 minutes by a trained operator.

## Rationale

Cleaning is the most frequently performed maintenance action on this device. If cleaning is difficult or time-consuming, busy lab staff will skip or shorten it, leading to cross-contamination. The design must make correct cleaning behavior the easy path. The 2-minute target matches typical lab workflow cadence between patient samples.

## Verification

- Surface roughness measurement on all sample-contact surfaces → Ra ≤ 0.8 µm
- Chemical compatibility immersion test: 1000 cycles with each approved disinfectant → no degradation
- Accessibility test: operator cleans all surfaces without tools → all areas reachable
- Carryover test: mix high-concentration control, clean per SOP, mix blank → analyte below detection limit
- Time-motion study: trained operator performs cleaning → ≤ 2 minutes

## Traceability

- **User Need:** STK-005 (Easy Cleaning and Cross-Contamination Prevention)
- **Risk:** FMEA-006 (Cross-Contamination Between Samples)
