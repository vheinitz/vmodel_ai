# Skill: Requirements-to-Risk Derivation Strategy

## Purpose
This skill defines how the **Requirements Engineer** derives risk management artifacts from requirements. It implements the ISO 14971:2019 risk management process integrated with IEC 62304, as taught by the Johner Institut and FDA guidance.

## References
- **ISO 14971:2019** — Application of risk management to medical devices
- **ISO 24971:2020** — Guidance on the application of ISO 14971
- **IEC 62304:2006+AMD1:2015** — Medical device software lifecycle
- **FDA**: "Risk Basics for Medical Devices" (CDRH, 2023)
- **Johner Institut**: ISO 14971 risk management methodology

---

## 1. Core Risk Concepts (FDA / ISO 14971)

### The Three H's
| Term | Definition (ISO 14971:2019) |
|------|---------------------------|
| **Hazard** | Potential source of harm |
| **Hazardous Situation** | Circumstances in which people, property, or environment is/are exposed to one or more hazards |
| **Harm** | Injury or damage to health of people, or damage to property or environment |

### Risk Definition
**Risk** = Combination of the **probability of occurrence of harm** and the **severity** of that harm.

```
HAZARD → SEQUENCE OF EVENTS → HAZARDOUS SITUATION (P1) → HARM (P2)
                                                                    │
                                              Risk = P1 × P2 × Severity
```

### Risk Analysis Steps (FDA 1996 Preamble + ISO 14971)
1. **Identification** of possible hazards, including use error
2. **Risk calculation/estimation**, normal AND fault conditions
3. **Risk acceptability determination**
4. **Risk reduced to acceptable level**
5. **Evaluation of changes** for introduction of new hazards

---

## 2. Strategy: Deriving Risk Management from Requirements

### Step-by-Step Process

```
For each REQUIREMENT:
  │
  ├── 1. HAZARD IDENTIFICATION
  │     What could go wrong if this requirement is NOT met?
  │     What could go wrong if this requirement is PARTIALLY met?
  │     What happens under ABNORMAL USE / FAULT CONDITIONS?
  │     What happens due to REASONABLY FORESEEABLE MISUSE?
  │
  ├── 2. HAZARDOUS SITUATION ANALYSIS
  │     In what circumstances would the hazard manifest?
  │     What sequence of events leads to exposure?
  │     What conditions affect P1 (probability of situation)?
  │
  ├── 3. HARM ASSESSMENT
  │     What is the potential HARM to patient, user, or environment?
  │     What is the SEVERITY of that harm? (1-10 scale)
  │     What conditions affect P2 (probability of harm from situation)?
  │
  ├── 4. RISK ESTIMATION
  │     Estimate P1 (probability of hazardous situation)
  │     Estimate P2 (probability of harm given the situation)
  │     P = P1 × P2
  │     Risk Level = f(Severity, P)
  │
  ├── 5. RISK EVALUATION
  │     Is the risk ACCEPTABLE per the risk acceptance matrix?
  │     If NO → Risk control required
  │     If YES → Document rationale, monitor
  │
  ├── 6. RISK CONTROL (if needed)
  │     Apply control hierarchy (strongest first):
  │       1. INHERENT SAFETY BY DESIGN (eliminate hazard)
  │       2. PROTECTIVE MEASURES (alarms, guards, interlocks)
  │       3. INFORMATION FOR SAFETY (labels, training, manuals)
  │     NOTE: Information is the WEAKEST measure (Johner)
  │     NOTE: RPN is NOT ISO 14971 conformant (Johner)
  │
  ├── 7. RESIDUAL RISK EVALUATION
  │     After controls applied, re-evaluate
  │     Is residual risk acceptable?
  │     Risk-Benefit analysis for unacceptable residual risks
  │
  └── 8. VERIFICATION OF EFFECTIVENESS
        How to verify each risk control works?
        → Link to test case in 06_Verification/
        → Document in FMEA verification column
```

### Derivation Rules

| Requirement Type | Default Hazard Analysis Approach |
|-----------------|--------------------------------|
| **Functional Requirement** | What if function fails? What if function produces wrong output? What under timing errors? |
| **Safety Requirement** | Already a risk control — trace backward to hazard, verify effectiveness |
| **Performance Requirement** | What if performance threshold is exceeded? Degraded performance? |
| **Interface Requirement** | What if interface fails? Wrong data transmitted? Timing violation? |
| **Usability Requirement** | What use errors are possible? What is reasonably foreseeable misuse? |
| **Regulatory Requirement** | Non-compliance → regulatory action. What patient harm results from non-compliance? |

---

## 3. Risk Control Hierarchy (ISO 14971 + Johner Institut)

Applied in strict order — you MUST try option 1 before option 2, and option 2 before option 3:

| Priority | Strategy | Example | Effectiveness |
|----------|----------|---------|---------------|
| **1** | **Inherent safety by design** | Redesign to eliminate hazard entirely; use fail-safe mechanism; physical barrier | Strongest |
| **2** | **Protective measures** in the device or manufacturing | Alarm on out-of-range condition; automatic shutoff; interlock preventing unsafe action | Medium |
| **3** | **Information for safety** | Warning label; instruction in manual; training requirement; on-screen warning | Weakest |

**Critical Rule (Johner):** Using ONLY information for safety is NEVER sufficient for high-severity risks. Information alone cannot control risks with Severity ≥ 8.

---

## 4. Risk Acceptance Matrix (Johner Institut Standard)

### Severity Scale (S)

| S | Severity | Medical Lab Device Example |
|---|----------|--------------------------|
| 1 | Negligible | No effect on result or safety |
| 2 | Minor | Cosmetic defect in report format |
| 3 | Slight | Minor workflow disruption, no result impact |
| 4 | Low | Delayed result, no clinical impact |
| 5 | Moderate | Inconvenience requiring workaround, results still correct |
| 6 | Significant | Potentially incorrect result, but flagged/alarmed |
| 7 | Major | Wrong result possible, no alarm — reversible injury possible |
| 8 | Critical | Wrong result likely — serious injury needing medical intervention |
| 9 | Catastrophic | Wrong result certain — permanent impairment or life-threatening |
| 10 | Fatal | Death of patient |

### Probability Scale (P = P1 × P2)

| P | Qualitative | Quantitative (per use) | Example |
|---|------------|----------------------|---------|
| 1 | Improbable | < 10⁻⁶ | Theoretically possible, never observed |
| 2 | Remote | 10⁻⁶ — 10⁻⁵ | Once in device lifetime |
| 3 | Occasional | 10⁻⁵ — 10⁻⁴ | Few times in device lifetime |
| 4 | Probable | 10⁻⁴ — 10⁻³ | May occur in some installations |
| 5 | Frequent | > 10⁻³ | Expected in normal use |

### Acceptance Matrix

```
              PROBABILITY →
SEVERITY      1(Improb)   2(Remote)   3(Occas)    4(Prob)    5(Freq)
↓ 10 Fatal    ALARP       UNACCEPT    UNACCEPT    UNACCEPT   UNACCEPT
   9 Catastr  ACCEPT      ALARP       UNACCEPT    UNACCEPT   UNACCEPT
   8 Critical ACCEPT      ALARP       ALARP       UNACCEPT   UNACCEPT
   7 Major    ACCEPT      ACCEPT      ALARP       ALARP      UNACCEPT
   6 Signif   ACCEPT      ACCEPT      ACCEPT      ALARP      ALARP
   5 Moderate ACCEPT      ACCEPT      ACCEPT      ACCEPT     ALARP
   4 Low      ACCEPT      ACCEPT      ACCEPT      ACCEPT     ACCEPT
   3 Slight   ACCEPT      ACCEPT      ACCEPT      ACCEPT     ACCEPT
   2 Minor    ACCEPT      ACCEPT      ACCEPT      ACCEPT     ACCEPT
   1 Neglig   ACCEPT      ACCEPT      ACCEPT      ACCEPT     ACCEPT

ACCEPT   = Risk acceptable, document rationale
ALARP    = Risk must be reduced As Low As Reasonably Practicable
UNACCEPT = Risk unacceptable, MUST be reduced
```

---

## 5. Common Mistakes in Risk Management (Johner Institut — 7 Most Frequent)

The RE agent MUST avoid these:

| # | Mistake | Correct Approach |
|---|---------|-----------------|
| 1 | **Risk management started too late** | Begin during requirements phase, not after development |
| 2 | **Using RPN (Risk Priority Number) as sole criterion** | RPN is NOT ISO 14971 conformant. Use severity/probability matrix |
| 3 | **Forgetting reasonably foreseeable misuse** | Always consider use errors, off-label use, deliberate misuse |
| 4 | **Information as sole risk control for high-severity risks** | Information cannot control Severity ≥ 8 risks alone |
| 5 | **Risk management not updated after changes** | Re-evaluate after every design/requirement change |
| 6 | **Missing the post-market phase** | Risk management continues through PMS, vigilance, field actions |
| 7 | **Risk management file incomplete or inconsistent** | Maintain single source of truth; all linked; traceable |
