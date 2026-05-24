# Rules: Artifact Frontmatter (Machine-Readable Schema)

> **Mandatory** for every artifact created or modified by an agent.
> Frontmatter is what makes the V-Model pipeline **automatic**: validators, traceability matrix builders, gate-readiness engines, and stale-link detectors all read these fields. Free-text body is for humans; frontmatter is for the system.

---

## 1. General Form

Every artifact file (one artifact per file) starts with a YAML frontmatter block:

```markdown
---
id: REQ-SW-AC-001
type: software-requirement
status: draft
created: 2026-05-24
updated: 2026-05-24
# ... type-specific keys ...
---

# Human-readable title

Free-text body. Rationale, prose, diagrams, etc.
```

Rules that always apply:

1. **One artifact per file.** Compiled views (e.g. a full SRS document) are *generated* from individual artifact files, never edited directly.
2. **Filename = `<id>.md`** (e.g. `REQ-SW-AC-001.md`, `FMEA-001.md`, `TC-INT-005.md`). Validator checks filename ↔ `id` match.
3. **All dates are ISO 8601 `YYYY-MM-DD`.**
4. **Lists use YAML array form**, never comma-separated strings: `risks: [FMEA-001, FMEA-002]`.
5. **Cross-references use the target's `id`.** Validator resolves them and reports broken links.
6. **Status values are from the closed vocabulary in §3.** No free-form status strings.
7. **Unknown keys are allowed** (forward-compatible) but the validator warns.

---

## 2. Artifact Types and Required Keys

The `type` field selects the schema. Required keys per type below; **omit any required key and the validator fails the artifact.**

### 2.1 `stakeholder-need` — User need

Location: `project/01_Requirements/01_StakeholderReqs/`
Filename: `STK-<NNN>.md`

```yaml
---
id: STK-001
type: stakeholder-need
status: draft | reviewed | approved | superseded
priority: must | should | could
source: <stakeholder role or document reference>
rationale: <why this need exists>
created: <YYYY-MM-DD>
updated: <YYYY-MM-DD>
approver: <role, e.g. "Lab Director">
---
```

### 2.2 `system-requirement` — System Pflichtenheft

Location: `project/01_Requirements/02_SystemReqs/`
Filename: `REQ-SYS-<NNN>.md`

```yaml
---
id: REQ-SYS-001
type: system-requirement
status: draft | reviewed | baselined | superseded
priority: must | should | could
category: functional | non-functional | safety | regulatory | interface
source: [STK-001]                  # >=1 upstream stakeholder needs
rationale: <text>
verification_method: test | inspection | analysis | demonstration
risks: [FMEA-001]                  # may be empty []
tests: [TC-SYS-001]                # may be empty [] before tests exist
created: <YYYY-MM-DD>
updated: <YYYY-MM-DD>
approver: <role>
---
```

### 2.3 `software-requirement` — SW Pflichtenheft (per component)

Location: `project/01_Requirements/03_SoftwareReqs/<COMPONENT>/`
Filename: `REQ-SW-<COMPONENT>-<NNN>.md`

```yaml
---
id: REQ-SW-AC-001
type: software-requirement
component: <COMPONENT code, e.g. AC, AD, FW>
status: draft | reviewed | baselined | superseded
priority: must | should | could
category: functional | non-functional | safety | regulatory | interface
source: [REQ-SYS-001]              # >=1 upstream system reqs
rationale: <text>
verification_method: test | inspection | analysis | demonstration
risks: [FMEA-001]
tests: [TC-INT-001, TC-UNIT-005]
safety_class: A | B | C             # required when category == safety
created: <YYYY-MM-DD>
updated: <YYYY-MM-DD>
approver: <role>
---
```

### 2.4 `fmea-entry` — Risk analysis entry (ISO 14971)

Location: `project/08_RiskManagement/`
Filename: `FMEA-<NNN>.md`

```yaml
---
id: FMEA-001
type: fmea-entry
status: draft | reviewed | controlled | accepted | superseded
hazard: <short hazard description>
hazardous_situation: <text>
harm: <text>
severity: 1..10
probability: 1..10
detection: 1..10
rpn: <severity * probability * detection, integer>
controls: [REQ-SW-AC-001]          # requirements implementing risk controls
residual_severity: 1..10
residual_probability: 1..10
residual_acceptable: true | false
related_requirements: [REQ-SYS-001]
tests: [TC-INT-001]
created: <YYYY-MM-DD>
updated: <YYYY-MM-DD>
approver: <role>
---
```

### 2.5 `test-case` — Verification test

Location: `project/06_Verification/<level>/`
Filename: `TC-<LEVEL>-<NNN>.md` where LEVEL ∈ {UNIT, INT, SYS, ARCH}

```yaml
---
id: TC-INT-001
type: test-case
level: unit | integration | system | architecture
status: draft | reviewed | passing | failing | blocked
verifies: [REQ-SW-AC-001]          # >=1 requirement IDs covered
mitigates: [FMEA-001]              # optional, FMEA IDs whose control this test verifies
preconditions: <text>
steps: <text>
expected_result: <text>
last_run: <YYYY-MM-DD or null>
last_result: pass | fail | not-run
created: <YYYY-MM-DD>
updated: <YYYY-MM-DD>
---
```

### 2.6 `architecture-component` — System or SW component

Location: `project/02_Architecture/{01_SystemArchitecture | 02_SoftwareArchitecture}/`
Filename: `COMP-<NNN>.md`

```yaml
---
id: COMP-001
type: architecture-component
layer: system | software | hardware
status: draft | reviewed | baselined | superseded
realizes: [REQ-SYS-001, REQ-SW-AC-001]
interfaces: [IF-001, IF-002]
created: <YYYY-MM-DD>
updated: <YYYY-MM-DD>
---
```

### 2.7 `design-module` — Detailed design

Location: `project/03_Design/`
Filename: `MOD-<NNN>.md`

```yaml
---
id: MOD-001
type: design-module
component: COMP-001
status: draft | reviewed | baselined | superseded
implements: [REQ-SW-AC-001]
source_path: src/<component>/<file>
created: <YYYY-MM-DD>
updated: <YYYY-MM-DD>
---
```

### 2.8 `adr` — Architecture Decision Record

Location: `project/02_Architecture/02_SoftwareArchitecture/decisions/`
Filename: `ADR-<NNN>.md`

```yaml
---
id: ADR-001
type: adr
status: proposed | accepted | superseded | deprecated
decision: <one-line summary>
context: <text>
consequences: <text>
supersedes: ADR-000                 # optional
created: <YYYY-MM-DD>
updated: <YYYY-MM-DD>
---
```

---

## 3. Closed Vocabulary

These string values are the only allowed ones. Validator rejects anything else.

| Field | Allowed values |
|-------|----------------|
| `status` (req/arch/design) | `draft`, `reviewed`, `baselined`, `superseded` |
| `status` (stakeholder-need) | `draft`, `reviewed`, `approved`, `superseded` |
| `status` (fmea-entry) | `draft`, `reviewed`, `controlled`, `accepted`, `superseded` |
| `status` (test-case) | `draft`, `reviewed`, `passing`, `failing`, `blocked` |
| `status` (adr) | `proposed`, `accepted`, `superseded`, `deprecated` |
| `priority` | `must`, `should`, `could` |
| `category` | `functional`, `non-functional`, `safety`, `regulatory`, `interface` |
| `verification_method` | `test`, `inspection`, `analysis`, `demonstration` |
| `safety_class` | `A`, `B`, `C` |
| `level` (test-case) | `unit`, `integration`, `system`, `architecture` |
| `layer` (component) | `system`, `software`, `hardware` |
| `last_result` | `pass`, `fail`, `not-run` |

---

## 4. ID Format

| Type | Pattern | Example |
|------|---------|---------|
| stakeholder-need | `STK-\d{3,}` | `STK-001` |
| system-requirement | `REQ-SYS-\d{3,}` | `REQ-SYS-001` |
| software-requirement | `REQ-SW-[A-Z]{2,4}-\d{3,}` | `REQ-SW-AC-001` |
| fmea-entry | `FMEA-\d{3,}` | `FMEA-001` |
| test-case | `TC-(UNIT|INT|SYS|ARCH)-\d{3,}` | `TC-INT-001` |
| architecture-component | `COMP-\d{3,}` | `COMP-001` |
| design-module | `MOD-\d{3,}` | `MOD-001` |
| adr | `ADR-\d{3,}` | `ADR-001` |

---

## 5. Validation Rules (enforced by `.pi/scripts/validate-artifacts.py`)

1. **Schema**: every required key for the artifact's `type` is present and non-empty.
2. **Filename match**: filename without `.md` equals `id`.
3. **ID format**: matches the regex for the artifact's `type`.
4. **Vocabulary**: closed-vocabulary fields only contain allowed values.
5. **Link integrity**: every ID referenced in `source`, `risks`, `tests`, `verifies`, `mitigates`, `realizes`, `implements`, `controls`, `related_requirements`, `supersedes` resolves to an existing artifact of an appropriate type.
6. **No orphans (when `status >= baselined`)**: baselined requirements must have at least one entry in `tests` and (if safety) at least one entry in `risks`.
7. **Stale links**: if a referenced artifact's `updated` date is newer than this artifact's `updated`, the reference is flagged `stale` (not an error, but surfaced).

Validator output → `dashboard/data/validation.json`.

---

## 6. Agent Contract

When an agent creates or modifies an artifact:

1. **Always include the complete frontmatter** for the type. Never partial.
2. **Update `updated:` to today's date** on every change.
3. **Set `status: draft`** on first creation. Status progression is gated by the QA agent or human reviewer.
4. **Cross-reference by ID only.** Do not embed prose links like "see requirement X" — they are invisible to the validator.
5. **Run `make validate` before declaring work done.** If validation fails, fix it; do not commit broken artifacts.

See also: `.pi/rules/document-naming.md`, `.pi/rules/vmodel-workflow.md`, `.pi/skills/traceability.md`.
