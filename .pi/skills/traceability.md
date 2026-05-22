# Skill: Traceability

## Purpose
Maintain and verify bidirectional traceability between requirements, architecture, design, implementation, tests, and risk controls.

## Usage
When invoked, this skill:
1. Scans all project artifacts
2. Builds or updates the traceability matrix
3. Identifies gaps (untraced items)
4. Reports traceability coverage metrics
5. Generates traceability reports

## Traceability Matrix Structure

| REQ-ID | Description | Component | Type | Arch-ID | Design-ID | Impl-Module | Test-ID | Risk-ID | Status |
|--------|-------------|-----------|------|---------|-----------|-------------|---------|---------|--------|
| REQ-SYS-001 | ... | AC | Functional | COMP-UI-01 | MOD-Login | src/login/ | TC-LOGIN-001 | FMEA-005 | Verified |
| REQ-SW-AC-042 | ... | AC | Safety | COMP-SAFE-01 | MOD-Result | src/results/ | TC-RESULT-015 | FMEA-012 | Open |

## Traceability Types

### Forward Traceability
```
Requirements → Architecture → Design → Implementation → Tests
```
Verify that every requirement is implemented and tested.

### Backward Traceability
```
Tests → Implementation → Design → Architecture → Requirements
```
Verify that every implemented/tested element is justified by a requirement.

### Risk Traceability
```
Risk → Risk Control → Requirement → Test → Verification
```

## Coverage Metrics

| Metric | Target | Formula |
|--------|--------|---------|
| Requirements Coverage | 100% | reqs_with_tests / total_reqs × 100 |
| Architecture Traceability | 100% | arch_items_linked_to_reqs / total_arch_items × 100 |
| Code Traceability (Class B/C) | 100% | modules_linked_to_design / total_modules × 100 |
| Test Coverage | ≥ 80% | tested_reqs / total_reqs × 100 |
| Safety Requirement Coverage | 100% | safe_reqs_with_tests / total_safe_reqs × 100 |
| Risk Control Coverage | 100% | verified_controls / total_controls × 100 |

## Gap Analysis Output
For each gap found, report:
- **Gap Type**: Missing trace / orphan item / broken link
- **Artifact ID**: Which item has the gap
- **Severity**: Critical (safety) / Major / Minor
- **Recommendation**: How to resolve

## Traceability Report Template
```markdown
# Traceability Report — [Date]

## Summary
- Total Requirements: N
- Requirements with Tests: N (XX%)
- Architecture Items Traced: N of M (XX%)
- Design Items Traced: N of M (XX%)
- Orphan Code Modules: N
- Untraced Risks: N

## Critical Gaps
| ID | Description | Recommended Action |
|----|-------------|-------------------|
| ... | ... | ... |

## Coverage Trend
[Include chart data for dashboard]
```
