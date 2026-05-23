# Skill: V-Model Phase Checklists

## Purpose
Provide comprehensive checklists for every V-Model phase to ensure completeness and compliance.

## Usage
When invoked, this skill analyzes the current project state and provides the appropriate phase checklist. The agent should:
1. Read `dashboard/data/status.json` to determine current phase
2. Load the appropriate checklist
3. Evaluate each item against project artifacts
4. Generate a status report with findings

## Phase Checklists

### Phase 0: Project Initiation
- [ ] PMP created and approved
- [ ] Project organization defined (roles, responsibilities)
- [ ] Resource plan established
- [ ] Communication plan created
- [ ] Development environment specified
- [ ] Toolchain defined (version control, CI/CD, issue tracking)
- [ ] Regulatory strategy documented
- [ ] Software safety classification performed
- [ ] Risk management plan approved
- [ ] QA plan approved
- [ ] CM plan approved

### Phase 1: Requirements Analysis
- [ ] Stakeholder requirements documented
- [ ] System requirements derived and baselined
- [ ] Software requirements derived and baselined
- [ ] Hardware requirements documented
- [ ] Interface requirements specified (LIS, device-control, image-output)
- [ ] Performance requirements specified with measurable acceptance criteria
- [ ] Safety requirements identified and classified
- [ ] Regulatory requirements captured
- [ ] Usability requirements defined with measurable targets
- [ ] Requirements traceability matrix established
- [ ] Requirements review completed
- [ ] All requirements have unique hierarchical IDs
- [ ] All requirements are testable
- [ ] Every requirement has a Verification Method and Approving Role
- [ ] Every NFR has at least one quantitative acceptance criterion
- [ ] IVD-specific requirements covered: carryover limits, sample volume, reagent stability, cleaning, time-to-first-result
- [ ] Recovery scenarios specified (power loss, emergency stop, interruption)
- [ ] Optional features explicitly tagged with Type/Priority, not just prose
- [ ] LIS requirements cover bidirectional communication and multi-LIS routing
- [ ] Safety gate requirements are verifiable (e.g., button disabled until condition met)
- [ ] Open questions section populated for stakeholder decisions needed
- [ ] Requirements quality checklist (`.pi/skills/requirements-quality-checklist.md`) completed
- [ ] Ambiguous requirements resolved
- [ ] Conflicting requirements resolved
- [ ] Requirements change process defined

### Phase 2: Architecture
- [ ] System architecture documented (SyAD)
- [ ] System decomposed into components
- [ ] Component interfaces specified
- [ ] Software architecture documented (SW-SAD)
- [ ] Architecture views documented (4+1)
- [ ] Data architecture defined
- [ ] Third-party components (SOUP) identified and documented
- [ ] Architecture reviewed against requirements
- [ ] Architecture decisions documented (ADR)
- [ ] Safety-critical components identified and segregated
- [ ] Fault-tolerance mechanisms defined
- [ ] Performance and scalability assessed
- [ ] Security architecture defined
- [ ] Architecture traceability to requirements verified

### Phase 3: Design
- [ ] Detailed software design documented (SDD)
- [ ] Module/class design completed
- [ ] Database schema defined
- [ ] API specifications completed
- [ ] UI design completed (screen flows, wireframes)
- [ ] Error handling design completed
- [ ] State machines defined
- [ ] Design patterns documented
- [ ] Design reviewed against architecture
- [ ] Design traceability to architecture verified
- [ ] Testability of design confirmed
- [ ] Coding standards defined

### Phase 4: Implementation
- [ ] All modules implemented
- [ ] Code follows coding standards
- [ ] Code documented (Doxygen comments)
- [ ] Unit tests implemented for all modules
- [ ] Unit test coverage ≥ 80%
- [ ] Safety-critical code coverage = 100%
- [ ] Static analysis performed (clang-tidy, cppcheck)
- [ ] Code reviews completed
- [ ] Build system configured (CMake)
- [ ] CI/CD pipeline operational
- [ ] Technical debt tracked
- [ ] Implementation traceability to design verified

### Phase 5: Integration
- [ ] Software components integrated
- [ ] Integration test plan created
- [ ] Integration tests executed
- [ ] All integration test cases passed
- [ ] Hardware-software integration tested
- [ ] External interfaces tested (LIS, CAN)
- [ ] Database integration tested
- [ ] Performance benchmarks met
- [ ] Defects documented and tracked
- [ ] Regression tests passed
- [ ] Integration report completed

### Phase 6: Verification (Testing)
- [ ] System test plan created
- [ ] System test cases linked to requirements
- [ ] All system tests executed
- [ ] Functional tests passed
- [ ] Performance tests passed
- [ ] Safety tests passed
- [ ] Regression tests passed
- [ ] Architecture compliance verified
- [ ] Traceability matrix complete (reqs → tests)
- [ ] Defect list reviewed and resolved
- [ ] Test report completed and reviewed
- [ ] Verification summary report signed

### Phase 7: Validation (OQ/PQ)
- [ ] Operational Qualification (OQ) plan created
- [ ] OQ tests executed in target environment
- [ ] Performance Qualification (PQ) plan created
- [ ] PQ tests executed with real workflows
- [ ] User acceptance testing completed
- [ ] Risk management file reviewed and closed
- [ ] Residual risks evaluated and accepted
- [ ] Intended use verified
- [ ] Labeling and user documentation reviewed
- [ ] Validation report completed
- [ ] Regulatory submission prepared

### Phase 8: Release & Deployment
- [ ] Release version tagged in Git
- [ ] Build artifacts archived
- [ ] Release notes created
- [ ] Installation/upgrade procedure documented
- [ ] User manual updated
- [ ] Training materials prepared
- [ ] Deployment to production completed
- [ ] Post-market surveillance plan activated
- [ ] Support handover completed

### Phase 9: Maintenance
- [ ] Change request process active
- [ ] Problem reports tracked
- [ ] Impact analysis for each change
- [ ] Regression testing after changes
- [ ] Updated documentation released
- [ ] Post-market surveillance data reviewed
- [ ] Vigilance reporting (if applicable)
- [ ] Periodic safety update reports
