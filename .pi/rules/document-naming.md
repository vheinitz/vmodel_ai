# Rules: Document Naming Convention

## Document Numbering Standard

### Format
```
[ProjectNumber]_[Component]_[DocumentType]_v[Major].[Minor].ext
```

### Project Number
- Assigned by your organization's project numbering system
- Example: `PRJ-2024-001`, `DEV-2025-042`

### Component Codes (Project-Specific)
Define your own component codes based on your system decomposition:

| Code | Component | Description |
|------|-----------|-------------|
| `SYS` | System-level | Cross-cutting, system-wide documents |
| `GUI` | GUI Application | User interface software |
| `CTRL` | Control Software | Device control software |
| `FW` | Firmware | Embedded firmware |

### Document Type Codes
| Code | Document Type |
|------|--------------|
| `PMP` | Project Management Plan |
| `SRS` | Software Requirements Specification |
| `SyRS` | System Requirements Specification |
| `SAD` | Software Architecture Document |
| `SDD` | Software Design Document |
| `SyAD` | System Architecture Document |
| `FMEA` | Failure Mode and Effects Analysis |
| `RMP` | Risk Management Plan |
| `QA` | Quality Assurance Plan |
| `CM` | Configuration Management Plan |
| `SWEP` | Software Development Plan |
| `TestPlan` | Test Plan |
| `TestReport` | Test Report |

### Version Format
- `v00.01` — First working draft
- `v00.02`, `v00.03` — Subsequent drafts
- `v01.00` — First approved version
- `v01.01` — Minor revision
- `v02.00` — Major revision

### Examples
```
PRJ001_SYS_SyRS_v01.00.md         — System Requirements v1.0
PRJ001_GUI_SRS_v01.00.md          — GUI Software Requirements v1.0
PRJ001_CTRL_SAD_v01.02.pdf        — Control Software Architecture v1.2
PRJ001_SYS_FMEA_v01.00.xlsx       — System FMEA v1.0
PRJ001_SYS_Traceability_v01.00.md — Requirements Traceability Matrix
```

### Directory Naming
- Use numeric prefixes for ordering: `00_`, `01_`, ...
- Entity names in English or your organization's language consistently
- Subdirectories for versions: `v1.0/`, `v2.0/`
- Internal working: `_RAW/`, `_Archiv/`, `_Trash/`
