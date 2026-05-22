# Skill: Risk Analysis Methods — Medical Device Software

## Purpose
Extended risk analysis methodology based on Johner Institut training transcripts, VDE Medical Software White Paper (2019), and ISO 14971:2019. Provides detailed procedures for PHA, FMEA, FTA, and software-specific risk analysis.

## Sources
- Johner Institut: "Risikomanagement & ISO 14971" training transcripts (Einführung, Risikoakzeptanz, Risikoanalyse, Risikobeherrschung, Nachgelagerte Phase)
- VDE (2019): *Medical Software White Paper* — 5 perspectives on risk management
- Wenner, H.C.: "Risk Management for Medical Devices" (VDE White Paper, 2019)
- IEC 62304:2006+AMD1:2015 §7 — Software risk management

---

## 1. Risk Analysis Method Selection

Per Johner Institut training, there are MULTIPLE analysis methods — FMEA is only one of them:

| Method | Best For | Software Applicability |
|--------|----------|----------------------|
| **PHA** (Preliminary Hazard Analysis) | Early-stage, broad hazard identification | Excellent — checklist + brainstorming |
| **FMEA** (Failure Mode and Effects Analysis) | Component-level, detailed failure analysis | Good — for software components |
| **FTA** (Fault Tree Analysis) | Top-down causal chain analysis | Excellent — trace root causes |
| **HAZOP** (Hazard and Operability Study) | Process flow, parameter deviation | Limited — more for chemical/process |
| **pFMEA** (Process FMEA) | Manufacturing and service processes | N/A for software product |

**Rule**: Start with PHA, refine with FMEA, use FTA for complex causal chains.

---

## 2. Preliminary Hazard Analysis (PHA) — Detailed Method

### Johner Institut Method (Transkript 8)

**Step 1: Brainstorming**
Think freely about what could go wrong. Ask: "What hazards could this device/software cause?" Even unstructured brainstorming is remarkably effective.

**Step 2: Checklist-Based (ISO 14971 Annex C)**
Use the systematic hazard checklist from ISO 14971:
- Electromagnetic energy
- Mechanical energy
- Thermal energy
- Chemical substances
- Biological contamination
- Radiation
- Information (wrong/missing data for software)

**Step 3: Internal and External Chain**
Analyze:
- What are the **outputs** of the device? (direct: energy, substances; indirect: information)
- What could be **wrong with those outputs**?
- How could wrong outputs affect the patient or user?

**Step 4: Systematic Documentation**
For each identified hazard, document:
- HAZ-ID
- Energy/Output type
- Potential hazardous situation
- Potential harm
- Initial severity estimate

---

## 3. FMEA — Detailed Method (Johner Transkript 9)

### Direction of Analysis
**FMEA thinks from LEFT to RIGHT**: Cause → Failure → Effect → Harm

```
Component → Failure Mode (what goes wrong?) 
         → External Behavior (what does the system do incorrectly?) 
         → System Effect (what is the consequence?) 
         → Harm (what injury/damage results?)
```

### FMEA Table Structure (per Johner)
| Column | Content | Example |
|--------|---------|---------|
| 1. Component | What are you analyzing? | Dose calculation software |
| 2. Failure Mode | What can go wrong in this component? | Developer bug, unit confusion (Gy vs Sv) |
| 3. External Behavior | What incorrect output does it produce? | Sends too-high dose to radiation source |
| 4. System Effect | What does this cause in the overall system? | System emits too much radiation for too long |
| 5. Harm | What injury results? | Radiation burn to patient |
| 6. Severity | How severe? (1-10) | 8 (Critical) |

### FMEA vs FTA Distinction
- **FMEA**: Forward analysis (cause → effect), starts with known component failure
- **FTA**: Backward analysis (effect → cause), starts with known harm/top event

---

## 4. Fault Tree Analysis (FTA) — Method

### When to Use FTA
- When a specific harm (top event) is identified with high severity
- To trace ALL possible causal chains leading to that harm
- For safety assurance cases (FDA requirement)

### FTA Construction (Per IEC 61025)
```
                    ┌─────────────────┐
                    │   WRONG RESULT   │  ← Top Event (Harm)
                    │   TO PATIENT     │
                    └────────┬────────┘
                             │ OR
              ┌──────────────┼──────────────┐
              │              │              │
    ┌─────────▼────┐  ┌──────▼──────┐  ┌───▼──────────┐
    │ Calculation  │  │ Calibration │  │ Sample-Result│
    │ Error        │  │ Drift       │  │ Mismatch     │
    └──────┬───────┘  └──────┬──────┘  └──────┬───────┘
           │ OR              │ OR             │ OR
    ┌──────┼──────┐    ┌─────┼─────┐    ┌─────┼─────┐
    │      │      │    │     │     │    │     │     │
  [Bug] [Unit] [Over  [Age] [Temp] [Freq] [Bar [Pos [Data
         Conv]  flow]              Calib] Code] Err] Link]
```

---

## 5. Software-Specific Risk Analysis (Johner Transkript 11)

### Why Software is Different
- Software does NOT fail randomly like hardware — failures are **systematic**
- Probability estimation (P1, P2) for software is particularly difficult
- Software failures are deterministic given the same inputs

### Software-Specific Approach
1. **Identify software items** that implement safety functions
2. **Analyze failure modes** for each software item
3. **Consider fault conditions**: What if inputs are wrong? What if timing is wrong?
4. **Consider use errors**: What if the user provides wrong data?
5. **Document SOUP risks**: Third-party libraries may have unknown failure modes

### VDE White Paper Key Insight (Wenner)
> "You cannot eliminate [all] effects because they belong to the nature of the device during its intended use. A scalpel cannot be dull — it will lose its intended use!"

The goal is NOT zero risk. The goal is **adequate safety** where **benefit outweighs residual risk**.

---

## 6. Risk Acceptance Matrix Construction (Johner Transkript 3-6)

### Key Principles
- The manufacturer must define **explicit, documented criteria** for risk acceptance
- This cannot be done by "gut feeling" — must be based on quantifiable measures
- The manufacturer must know: **"How many patients may the product statistically kill?"**
- Compare: "How many lives does the product save?" → Benefit must be ≥ 10× the risk

### Matrix Construction Steps
1. Define severity scale (1-10) based on harm type
2. Define probability scale (1-5) based on occurrence likelihood
3. Color-code regions: Green (Accept), Yellow (ALARP), Red (Unacceptable)
4. Management approves the matrix (NOT the risk manager or developers!)
5. Use the matrix to evaluate every identified risk

### Benefit-Risk Analysis
For ALARP risks, the manufacturer must justify:
- What is the quantified benefit of the device?
- What is the quantified residual risk?
- Is the benefit/risk ratio acceptable?
- What additional risk controls were considered but rejected as not reasonably practicable?

---

## 7. Risk Control Effectiveness (VDE White Paper)

### 5 Perspectives on Risk Management Success (VDE 2019)

1. **Systematic Risk Management** (Wenner): Controls and monitors all risks throughout lifecycle
2. **Clinical Evidence** (Kern): Clinical studies identify and quantify real-world risks
3. **Traceability** (Ankele): Must be able to trace any product back to its components — required for recalls
4. **Liability** (Handorn): Manufacturer is liable — risk management is also legal protection
5. **Data Protection** (Spyra): GDPR applies — risk management must include data security risks

### Cybersecurity Integration (VDE + MDCG 2019-16)
- IT security risks must be included in the risk management file
- Consider: unauthorized access, data breach, ransomware, firmware tampering
- Security risk control: encryption, authentication, secure boot, signed updates

---

## 8. Post-Market Risk Management (Johner Transkript 14)

Risk management does NOT end at product release:

- **Post-Market Surveillance (PMS)**: Collect and analyze real-world usage data
- **Vigilance Reporting**: Serious incidents → report to authorities within defined timelines
- **Field Safety Corrective Actions (FSCA)**: Recall or field correction if new risks emerge
- **Periodic Safety Update Reports (PSUR)**: Regular review of risk/benefit profile
- **Continuous Risk File Update**: New hazards identified post-market → added to FMEA

---

## 9. Common Risk Management Documents Checklist

Per Johner Institut and VDE White Paper:

- [ ] Risk Management Plan (RMP) — defines process, roles, acceptance criteria
- [ ] Hazard Identification List (PHA output) — all identified hazards
- [ ] System FMEA — component-level failure analysis
- [ ] Software FMEA — software-specific failure modes
- [ ] Fault Tree Analysis (for top 3-5 highest-risk scenarios)
- [ ] Risk/Benefit Analysis — numerical justification for ALARP risks
- [ ] Risk Control Verification Records — test results proving controls work
- [ ] Overall Residual Risk Evaluation — summary of all residual risks
- [ ] Risk Management Report — final sign-off before release
- [ ] Post-Market Surveillance Plan — ongoing risk monitoring
