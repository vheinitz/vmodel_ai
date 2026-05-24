# Example: Coagulation Analyzer (illustrative, generic)

This directory is a **format reference**, not a real product. It shows the V-Model XT
template instantiated with a small, complete, traceable set of artifacts.

## What this is

A miniature project for a generic blood-coagulation analyzer (PT/aPTT measurement).
It exists so that:

1. Agents have a known-good example to copy the artifact format from on first contact.
2. Validator (`make validate-example`) and gate engine (`make gates-example`) have a
   permanent, deterministic fixture to run against in CI.
3. A new user can read it end-to-end in ~15 minutes to understand the trace flow.

## What it contains

```
examples/coag-analyzer/
├── README.md                                    (this file)
├── project/
│   ├── 01_Requirements/
│   │   ├── 01_StakeholderReqs/   STK-001..005   (5 stakeholder needs)
│   │   ├── 02_SystemReqs/        REQ-SYS-001..005 (5 system reqs)
│   │   └── 03_SoftwareReqs/AC/   REQ-SW-AC-001..005 (5 software reqs for the AC component)
│   ├── 06_Verification/
│   │   ├── 01_UnitTests/         TC-UNIT-001
│   │   ├── 02_IntegrationTests/  TC-INT-001..002
│   │   └── 03_SystemTests/       TC-SYS-001
│   └── 08_RiskManagement/        FMEA-001..002 (2 risk entries with controls)
```

## Trace chain (single example)

```
STK-005  Patient safety: no incorrect results
  └─→ REQ-SYS-005  System SHALL suppress QC-failing results
        └─→ REQ-SW-AC-005  AC SHALL detect optical-sensor saturation
              ├─→ TC-INT-001  Saturation suppression integration test
              └─← FMEA-001    Hazard: incorrect PT due to sensor saturation
                                (controlled by REQ-SW-AC-005, verified by TC-INT-001)
```

Every artifact follows `.pi/rules/artifact-frontmatter.md`. All links resolve;
validator and gate engine both pass on this example.

## NOT a real product

The numbers, hazards and controls here are realistic-looking but illustrative.
**Do not use this example as the basis for a real device dossier.**
