# Rules: V-Model XT Workflow

## Phase Sequence and Dependencies

### Predecessor/Successor Relationships
Each phase has defined entry and exit criteria:

| Phase | Entry Criteria | Exit Criteria |
|-------|---------------|---------------|
| **User Needs (Lastenheft)** | Project approved (G1) | User needs documented, reviewed. Written in stakeholder language. |
| **Risk Analysis** | User needs documented | Hazards identified, risk controls defined → feed into System Reqs |
| **System Reqs (Pflichtenheft)** | User needs + Risk Analysis complete | System reqs baselined, includes safety reqs from risk controls, traced to user needs (G2). Same quality standards: measurable, attributed, approved. |
| **System Architecture** | System reqs baselined | Architecture defined, reviewed (G3) |
| **SW Reqs** | System architecture defined | SW reqs baselined, traced to system reqs (G2) |
| **SW Architecture** | SW reqs baselined | SW architecture defined, reviewed (G3) |
| **SW Design** | SW architecture defined | Detailed design completed, reviewed (G4) |
| **Implementation** | SW design completed | Code implemented, unit tested (G5) |
| **SW Integration** | Implementation completed | SW integration tested (G6) |
| **System Integration** | SW + HW ready | System integration tested (G6) |
| **System Tests** | System integrated | System tests passed (G7) |
| **Validation (OQ/PQ)** | System tests passed | Validation completed (G8) |

## Traceability Rules

Every artifact must be traceable:
- **User Needs → Risk Analysis**: Each user need assessed for hazards
- **Risk Analysis → System Reqs**: Risk controls become safety requirements
- **Requirements → Architecture**: Each requirement allocated to ≥1 architectural component
- **Architecture → Design**: Each architectural component has ≥1 design element
- **Design → Implementation**: Each design element has corresponding source code
- **Requirements → Tests**: Each requirement has ≥1 test case
- **Risks → Requirements → Tests**: Risk controls traced to requirements and tests

### Mandatory Requirement Attributes (every requirement document)
- **Unique ID** with hierarchical numbering (insertion-safe)
- **Priority**: Mandatory / Optional
- **Verification Method**: Test / Inspection / Analysis / Demonstration
- **Approving Role**: Named stakeholder (Clinical Stakeholder, Lab Director, QA, Regulatory Affairs, Service)
- **Source**: Where this requirement originated

See `.pi/skills/requirements-quality-checklist.md` for the full quality gate.

## Document State Machine
```
Draft → In Review → Approved → Baselined → Superseded
         ↓            ↓
      Rework       Obsolete
```

## Version Numbering
- **Draft**: v00.01, v00.02, ...
- **Approved**: v01.00
- **Minor Update**: v01.01, v01.02, ...
- **Major Revision**: v02.00, v03.00, ...

## Medical Device Compliance Rules

### Document Sign-off Requirements (IEC 62304)
- All documents must be reviewed by an independent reviewer
- For Class C software: independent verification team
- Electronic signatures or physical sign-off required

### Change Control
- All changes to baselined documents require Change Request (CR)
- CR must include impact analysis
- CR must be approved by Change Control Board (CCB)

### Configuration Management
- All artifacts under version control (Git)
- Unique identifiers for all configuration items
- Configuration status accounting
- Baseline management

### IEC 62304 Software Development Process
1. **Software Development Planning** (§5.1)
2. **Software Requirements Analysis** (§5.2)
3. **Software Architectural Design** (§5.3)
4. **Software Detailed Design** (§5.4)
5. **Software Unit Implementation and Verification** (§5.5)
6. **Software Integration and Integration Testing** (§5.6)
7. **Software System Testing** (§5.7)
8. **Software Release** (§5.8)

## Toolchain Rules
- **Version Control**: Git with GitLab
- **Build**: CMake ≥ 3.16
- **CI/CD**: GitLab CI
- **Documentation**: Markdown for drafts, MS Office for formal documents
- **Requirements**: Markdown + traceability in YAML/JSON
- **Test Management**: Test cases in Markdown, automated tests in CTest
- **Static Analysis**: clang-tidy, cppcheck (mandatory for medical device SW)
