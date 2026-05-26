---
id: REQ-SYS-090
type: system-requirement
status: draft
priority: must
category: safety
source: [STK-001, STK-003]
rationale: Power loss during an active mixing cycle results in a partially-mixed sample. If the operator does not know the cycle was interrupted, the sample may be forwarded for analysis, producing an incorrect result. The device must clearly indicate an interrupted cycle and must not auto-resume.
verification_method: test
risks: [FMEA-010]
tests: []
created: 2026-05-26
updated: 2026-05-26
approver: Safety Officer
---

# REQ-SYS-090: Power Loss Handling and Recovery

## Requirement

1. **Interruption Detection:** The system shall detect that a mixing cycle was in progress when power was lost, and on power restoration shall enter an "Interrupted" state with a distinct error indication (flashing amber or red indicator, different pattern from the standard error state).
2. **No Auto-Resume:** The system shall NOT automatically resume mixing on power restoration. The mixing cycle must be manually restarted by the operator via the start button after confirming the sample condition.
3. **Cycle State Memory:** The system shall retain the fact that a cycle was interrupted across a power loss of at least 60 seconds without relying on battery-backed memory (i.e., via non-volatile storage written before cycle start and cleared on successful completion).
4. **Operator Guidance:** In the "Interrupted" state, the user manual and any on-device labeling shall guide the operator to: (a) visually inspect the sample, (b) discard and re-prepare or re-mix the sample at their discretion, (c) press start to begin a new cycle.

## Rationale

Power loss is a foreseeable event in a laboratory (power outages, accidental cord disconnection, circuit breaker trips). If the device silently resumes or shows "ready" after a power cycle, the operator will not know the sample is only partially mixed. This is a latent failure that can affect clinical decisions.

## Verification

- Power interruption test: cut power mid-cycle, wait 30 seconds, restore power — verify "Interrupted" state indicated
- No auto-resume test: confirm device does not start mixing on power restoration
- Memory retention test: cut power mid-cycle, wait 60 seconds, restore — verify interrupted state persists
- Operator scenario walkthrough: verify labeling/display guides operator to correct action

## Traceability

- **User Needs:** STK-001 (Uniform Mixing), STK-003 (Electric-Powered Operation)
- **Risk:** FMEA-010 (Power Loss During Mixing)
