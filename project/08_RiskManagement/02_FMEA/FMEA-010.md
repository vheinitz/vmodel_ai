---
id: FMEA-010
type: fmea-entry
status: draft
hazard: Power loss during mixing → incomplete mixing and unreported failure
hazardous_situation: Mains power is interrupted during a mixing cycle (power outage, cord unplugged, circuit breaker trip). The mixing process stops mid-cycle. Sample is partially mixed. When power returns, the device either restarts mixing without user awareness of the interruption, or sits idle — but there is no indication that the previous cycle was incomplete.
harm: Partially mixed sample forwarded for analysis → incorrect diagnostic result. If restart behavior is ambiguous, operator may assume mixing completed but it did not, or may mix the same sample twice (over-processing).
severity: 6
probability: 3
detection: 6
rpn: 108
controls: [REQ-SYS-090]
residual_severity: 6
residual_probability: 3
residual_acceptable: false
related_requirements: [REQ-SYS-010, REQ-SYS-090]
tests: []
created: 2026-05-26
updated: 2026-05-26
approver: Risk Manager
---

# FMEA-010: Power Loss During Mixing

## Function
Uniform mixing (STK-001), electric operation (STK-003), status indication (STK-007)

## Failure Mode
Mains power is lost during an active mixing cycle. Mixing stops before the cycle completes. The sample is partially or unevenly mixed. On power restoration, the device does not clearly indicate that the previous cycle was interrupted.

## Cause
- Mains power outage (building-level)
- Power cord accidentally unplugged or loose connection
- Circuit breaker trips (device fault or external)
- Internal power supply failure
- Brown-out (voltage dip causing microcontroller reset)

## Effect
- Sample is partially mixed — concentration gradients persist
- Operator may not realize mixing was incomplete → forwards sample for analysis
- Wrong diagnostic result → clinical decision error
- If device auto-restarts mixing on power return → double-processing of sample (may be inappropriate for some sample types)

## Risk Control (Proposed)
1. **Design**: Power-loss detection circuit; on power restoration, device enters "interrupted" state with distinct error indication (red flashing) — does NOT auto-resume mixing; status saved in non-volatile memory so it survives power cycle
2. **Protective**: "Cycle incomplete" indication on power-up (distinct from "ready" state); operator must explicitly acknowledge and restart the cycle
3. **Information**: Label "Do not unplug during operation"; SOP to discard and re-prepare sample if power loss occurred during mixing

## Verification
- Power interruption test — cut power mid-cycle, restore, verify "interrupted" indication
- Verify device does not auto-resume mixing on power return
- Verify status memory survives 30-second power loss
- Brown-out immunity test
