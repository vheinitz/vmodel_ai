# Quality Assurance Plan (QA Plan)

**Document ID:** {PROJECT_NUMBER}_CD_QA_v{MAJOR}.{MINOR}  
**Project:** {PROJECT_NAME}  
**Version:** v00.01 (Draft)  
**Date:** {DATE}  
**Author:** QA Manager  

---

## 1. Purpose
This QA Plan defines quality assurance activities, responsibilities, and standards for {PROJECT_NAME}, ensuring compliance with ISO 13485:2016 and IEC 62304.

## 2. Quality Objectives
| Objective | Metric | Target |
|-----------|--------|--------|
| Requirements coverage | % reqs with tests | 100% |
| Code coverage | Line coverage % | ≥ 80% (100% safety-critical) |
| Defect density | Defects / KLOC | < 2.0 |
| On-time delivery | Schedule variance | < 10% |
| Review effectiveness | Defects found in review | > 70% |
| Process compliance | Audit findings | 0 major non-conformances |

## 3. QA Activities by Phase

| Phase | QA Activity | Frequency |
|-------|------------|-----------|
| Project Initiation | Review PMP completeness | Once |
| Requirements | Requirements review | Per document |
| Architecture | Architecture review | Per document |
| Design | Design review | Per module |
| Implementation | Code review, static analysis | Per commit |
| Testing | Test review | Per test cycle |
| Validation | Validation review | Per OQ/PQ |
| Release | Final audit | Once |

## 4. Document Review Process

### 4.1 Review Types
- **Peer Review:** Informal, by colleague
- **Walkthrough:** Semi-formal, author presents
- **Technical Review:** Formal, by review team
- **Inspection:** Most formal, by trained inspectors

### 4.2 Review Checklist
- [ ] Document follows template
- [ ] All sections completed
- [ ] Traceability links present
- [ ] No conflicts with other documents
- [ ] Terminology consistent
- [ ] Regulatory requirements addressed
- [ ] Risk items linked (if applicable)

## 5. Audit Schedule

| Audit | Type | Date | Auditor |
|-------|------|------|---------|
| Phase 1 Audit | Internal | {DATE} | QA Manager |
| Phase 2 Audit | Internal | {DATE} | QA Manager |
| Supplier Audit | External | {DATE} | QA Manager |
| Pre-Certification | External | {DATE} | Notified Body |

## 6. Non-Conformance and CAPA

### 6.1 Non-Conformance Categories
- **Major:** Process failure that could affect product quality
- **Minor:** Isolated deviation from procedure
- **Observation:** Improvement opportunity

### 6.2 CAPA Process
1. Identify non-conformance
2. Contain immediate issue
3. Root cause analysis
4. Corrective action
5. Preventive action
6. Effectiveness verification

## 7. Metrics and Reporting

### 7.1 Monthly QA Report
- Quality metrics dashboard
- Audit findings summary
- CAPA status
- Process improvement initiatives

### 7.2 Phase QA Report
- Phase checklist completion
- Document review status
- Gate criteria verification
- Recommendation for next phase

---

*Template version: 1.0 | ISO 13485:2016 compliant*
