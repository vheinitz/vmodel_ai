# Skill: Requirements Quality Checklist

## Purpose
Ensure every requirement — stakeholder, system, or software — meets medical device quality standards before baselining. This checklist encodes lessons learned from regulatory reviews and prevents the most common audit findings.

## When to Use
- After drafting any requirements document (Stakeholder, System, or Software)
- Before circulating for formal review
- Before baselining (G2 decision gate)

## Mandatory Requirement Attributes

Every requirement must carry these attributes:

| Attribute | Required | Example |
|---|---|---|
| **Unique ID** | ✅ | `UR-1.1`, `NFR-SAF-01`, `REQ-SYS-003` |
| **Priority** | ✅ | Mandatory / Optional |
| **Verification Method** | ✅ | Test, Inspection, Analysis, or Demonstration |
| **Approving Role** | ✅ | Clinical Stakeholder, Lab Director, QA, Regulatory Affairs, Service |
| **Source** | Recommended | Stakeholder, Regulation, Risk Analysis, Clinical Need |
| **Traceability Parent** | Required for derived reqs | Which parent requirement this derives from |

## Structural Checklist

- [ ] Requirements use hierarchical IDs (e.g., UR-1.1, UR-1.1.1) allowing insertion without renumbering
- [ ] Child requirements have explicit sub-IDs (UR-5.3.1, not just a sub-bullet)
- [ ] NFRs use category-scoped IDs: `NFR-SAF-01`, `NFR-PERF-01`, `NFR-REL-01`, etc.
- [ ] Document has an explicit "Open Questions" section for items requiring stakeholder input
- [ ] Document states its level (Stakeholder / System / Software) and does not leak downward
- [ ] A "How to Read This Document" section explains ID conventions and attribute columns

## Verifiability Checklist

- [ ] Every requirement uses **exactly one** of: shall / should / may (per RFC 2119)
- [ ] `shall` = mandatory, testable, must pass for release
- [ ] `should` = recommended, deviation requires justification
- [ ] `may` = optional capability
- [ ] No requirement uses "likely", "adequate", "sufficient", "appropriate", "reasonable" without a measurable companion requirement
- [ ] Every NFR has at least one quantitative acceptance criterion with a number and unit
- [ ] Performance NFRs state explicit throughput, latency, resolution, or accuracy targets
- [ ] Safety NFRs state explicit hazard mitigations, not just "shall be safe"

## Content Completeness Checklist

### Clinical / Domain Coverage
- [ ] Intended medical purpose stated
- [ ] Patient population defined
- [ ] Use environment specified
- [ ] All substrate types enumerated
- [ ] Clinical workflow steps described (sample prep → incubation → wash → conjugate → microscopy → interpretation)
- [ ] Quality control requirements (positive/negative controls per run)

### User Coverage
- [ ] All user roles defined (operator, reviewer, admin, service)
- [ ] Each role's responsibilities listed
- [ ] Role-based access control specified
- [ ] Training materials required (role-specific)

### Functional Coverage — Mandatory Areas
- [ ] Sample processing automation (dilution, transfer, incubation, wash, conjugate, mounting)
- [ ] Multi-well / multi-slide handling
- [ ] Flexible dilution schemes
- [ ] Temperature monitoring and control
- [ ] Humidity monitoring (base) and optional active control
- [ ] Processing error detection and handling
- [ ] Sample and slide identification (barcode)
- [ ] Barcode symbology flexibility (at minimum Code 128, Code 39, DataMatrix)
- [ ] Automated microscope positioning and image capture
- [ ] Autofocus across varying signal intensities and substrate types
- [ ] Exposure optimization (avoid under/overexposure)
- [ ] Tissue overview / mosaic imaging
- [ ] Configurable per-test image settings
- [ ] Automated pre-classification with defined NPV target (≥ 95%)
- [ ] Configurable pre-classification thresholds
- [ ] Pre-classification transparency (which criteria drove the assessment)
- [ ] Image review workspace (navigate, zoom, compare)
- [ ] Manual classification override (positive / negative / borderline)
- [ ] Negative result safety gate (MUST view all images before batch confirm)
- [ ] Sample-centric result view (cross-slide, cross-test grouping)
- [ ] Fluorescence pattern assignment
- [ ] Image annotation
- [ ] Follow-up recommendations
- [ ] Endpoint titer estimation (suggestion only, NOT automatic reporting)
- [ ] Re-classification with audit trail
- [ ] Diagnostic report generation (images, results, traceability, follow-ups)
- [ ] Report customization (header, logo, contact)
- [ ] LIS order receipt
- [ ] LIS result transmission
- [ ] **Bidirectional** LIS communication (push + query-response)
- [ ] **Multi-LIS** routing by configurable rules
- [ ] LIS communication status monitoring
- [ ] Manual LIS interaction (trigger, retry, review pending)
- [ ] User authentication and session management
- [ ] Password policies (complexity, expiration, re-use prevention)
- [ ] User account lifecycle management
- [ ] Result storage and retrieval by multiple criteria
- [ ] Long-term archiving
- [ ] Storage capacity monitoring and run prevention
- [ ] Backup and restore
- [ ] Support data export (without patient data unless authorized)
- [ ] Test protocol configuration (no software changes needed)
- [ ] Guided calibration procedure
- [ ] Configuration protection (corruption, unauthorized change, audit log)
- [ ] Configuration portability (export/import)
- [ ] Run status monitoring (current step, ETA, hardware states)
- [ ] Remote notification (completion, error, consumables)
- [ ] **Guided cleaning/decontamination** with step confirmation and log
- [ ] Walk-away (fully automated) mode
- [ ] Supervised mode
- [ ] Emergency stop
- [ ] **Power-loss / interruption recovery** (resume or cancel with loss report)

### Functional Coverage — Critical IVD-Specific Areas (Frequently Missed)
- [ ] **Well-to-well carryover** limit specified (≤ 1:10⁵)
- [ ] **Sample volume** per test well specified (≤ 50 µL dead-volume-exclusive)
- [ ] **Time to first result** specified (≤ 90 min for standard panel)
- [ ] **Reagent onboard stability** tracking with configurable limits

### Non-Functional Coverage
- [ ] Patient safety (human review required for all diagnostic decisions)
- [ ] Operator safety (panel detection, auto-stop, safe motor release)
- [ ] Data safety (loss, corruption, unauthorized access)
- [ ] Fail-safe behavior (safe state on failure, consistent recovery on restart)
- [ ] **Measurable** throughput (samples per shift)
- [ ] UI responsiveness during automation
- [ ] **Measurable** image quality (resolution, focus accuracy vs. reference)
- [ ] Operational continuity
- [ ] Graceful error recovery
- [ ] Data integrity
- [ ] **Calibration stability** (≥ 14 days without drift > 1 well width)
- [ ] **Measurable** training time
- [ ] Error prevention in safety-critical operations
- [ ] Clear feedback and actionable error messages
- [ ] Multi-language support (per user, persistent)
- [ ] Service diagnostics
- [ ] Software update preservation
- [ ] Continuous diagnostic logging
- [ ] Custom protocol definition without manufacturer intervention
- [ ] Slide format compatibility
- [ ] LIS standards compatibility
- [ ] Role-specific training materials
- [ ] IEC 62304 compliance
- [ ] ISO 14971 risk management
- [ ] ISO 13485 quality management
- [ ] IVDR (EU) 2017/746 compliance
- [ ] Audit trail (who, what, when; protected from modification)
- [ ] 21 CFR Part 11 support (design support; activation for FDA markets)

## Anti-Patterns — Requirements That Will Fail Review

| Anti-Pattern | Example | Fix |
|---|---|---|
| Qualitative NFR | "The device shall be fast enough" | "The device shall process ≥ 48 samples per 8-hour shift" |
| Vague performance | "Images shall be of sufficient quality" | "Resolution ≥ 5 MP; SNR variation ≤ 10% vs. manual reference" |
| Missing recovery scenario | Only defines normal operation | Add: "After power loss, resume from last completed step or cancel with loss report" |
| Single-direction LIS | "Send results to LIS" | Add: "Receive orders from LIS", "Bidirectional query-response" |
| Unverifiable optional | "May optionally include pattern recognition" | Tag as "Optional — Software Add-On" with Type column |
| Implementation leak | "The system shall store data in a relational database" | "The system shall store results in a structured, queryable format" |
| Technology lock-in | "The system shall communicate via ASTM E1394" | "The system shall communicate using established laboratory data exchange standards" |
| No approving role | Only states what the system does | Add Approving Role column: Clinical Stakeholder, QA, etc. |
| Ambiguous "assist" | "The device shall assist in estimating titer" | "The device may suggest a dilution step; shall not auto-report titer without confirmation" |
| Weak safety gate | "Reviewer must inspect all wells" | "Confirm button disabled until all images explicitly opened and viewed in current session" |

## Self-Review Questions

After completing a requirements document, ask:

1. **Can an independent tester write a test case for every `shall` requirement without asking me?**
2. **Would a regulatory auditor accept every NFR as stated, or would they ask "how do you measure this?"**
3. **If the device loses power mid-run, does the document say what happens next?**
4. **Is there a named human who approves each requirement?**
5. **Does every optional feature have an explicit Type/Priority tag, not just prose?**
6. **Are all numbers traceable to a clinical or regulatory source, not an engineering estimate?**
7. **Would this document still make sense if we rebuilt the device with a completely different technology stack?**
