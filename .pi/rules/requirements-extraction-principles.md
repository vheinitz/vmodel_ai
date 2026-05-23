# Rule: Requirements Extraction from Existing Products

## When This Rule Applies
You are extracting requirements from an **existing product** (codebase, documentation, specifications) for the purpose of a **rewrite, re-architecture, or relaunch**. The existing artifacts are **reference material only** — they document an old implementation that will be replaced.

## The Cardinal Rule

> **Derive *what* the device must do, never *how* the old implementation did it.**

The existing code and documents tell you which **user needs, clinical workflows, and business capabilities** the product fulfills. They do **not** tell you what the new system's requirements are — those must be expressed independently, at the business and user level.

## What to EXCLUDE from Requirements (Common Anti-Patterns)

### ❌ Technology Stack
| Wrong (describes old implementation) | Reason |
|---|---|
| "The system shall use Qt 4.8.4" | Technology choice, not a requirement |
| "The system shall communicate via FTDI USB" | Bus/protocol, not a requirement |
| "The system shall store data in SQLite" | Database choice, not a requirement |
| "The system shall use OpenCV 2.4 for image processing" | Library choice, not a requirement |
| "The system shall read configuration from Windows registry" | Platform mechanism, not a requirement |
| "The system shall use TCP port 2501 for license check" | Protocol + port, not a requirement |

### ❌ Implementation Architecture
| Wrong (describes old code structure) | Reason |
|---|---|
| "The system shall have a CaptureController state machine" | Internal class, not a user requirement |
| "The system shall use a DataPool publish-subscribe pattern" | Design pattern, not a requirement |
| "The system shall provide modal dialogs for user management" | UI implementation, not a requirement |
| "The system shall store images as PNG with companion XML files" | File format choice, not a requirement |
| "The system shall spawn subprocesses for IFA and RC" | Process architecture, not a requirement |

### ❌ Concrete Numbers from Old Implementation
| Wrong (describes old behavior) | Reason |
|---|---|
| "The system shall capture images at 30 FPS at 1024×768" | Old performance characteristic |
| "The system shall process 260 images in 2.5 minutes" | Old benchmark, not a requirement |
| "The system shall support up to 240 PNG files per slide" | Old format limitation |
| "The system shall move axes at 16 mm/s" | Old calibration value |
| "The system shall timeout barcode reads after 1000 ms" | Old timing parameter |

### ❌ UI Layout and Widgets
| Wrong (describes old UI) | Reason |
|---|---|
| "The system shall use a stacked-widget pattern" | Widget toolkit detail |
| "The system shall have screens: LoginScreen, SelectionScreen, ..." | Old screen decomposition |
| "The system shall display error messages in red exclamation marks" | Old visual design choice |

### ❌ Third-Party Product Names
| Wrong | Reason |
|---|---|
| "Märzhäuser Tango axis controller" | Vendor name |
| "The Imaging Source camera" | Vendor name |
| "Basler / IDS camera SDK" | Vendor name |
| "InnoSetup installer" | Tool name |
| "reatha.de notification API" | Service provider |

## What TO Extract (Correct Derivation)

### ✅ User Workflows and Clinical Needs
From old documentation saying "the user clicks Capture and the system processes all slides":
→ **Requirement**: "The device shall automatically process all loaded slides in a single run without requiring operator intervention between slides."

### ✅ Operational Modes
From old code implementing "walk-away" with UUID handshake:
→ **Requirement**: "The device shall support a fully automated operational mode where the operator loads samples, starts the run, and returns after all processing and image acquisition is complete."

### ✅ Safety and Access Control
From old user management with roles "user, superuser, administrator":
→ **Requirement**: "The device shall enforce role-based access control. Only authorized administrators shall be able to manage user accounts."

### ✅ Medical / Clinical Domain Rules
From old cut-off parameter definitions (HWMN, BLMX, BRMX):
→ **Requirement**: "Image pre-classification shall evaluate fluorescence signal intensity, background level, and signal-to-background ratio against configurable thresholds."

### ✅ Data Management Needs
From old directory structure with timestamps, slide folders, classified subfolders:
→ **Requirement**: "The device shall organize captured images and results in a structured manner that allows unambiguous identification of the processing run, slide, well, and image."

### ✅ External Integration Needs
From old ASTM E1394 LIS communication:
→ **Requirement**: "The device shall be capable of receiving test orders from and transmitting diagnostic results to a Laboratory Information System using established laboratory communication standards."

### ✅ Configurability Needs
From old helios.cfg with per-test-type exposure settings:
→ **Requirement**: "Image acquisition parameters shall be configurable per test type to accommodate differences in fluorescence characteristics between test substrates."

### ✅ Quality and Traceability Needs
From old traceability XML with kit lots, operator, timestamps:
→ **Requirement**: "The device shall record for each processing run: reagent and control lot identifiers, operator identification, and timestamps for all processing steps."

## The Self-Test
After writing a requirement, ask:

> **"If we rewrote this device from scratch using a completely different technology stack, would this requirement still be valid?"**

- If **YES** → it belongs in the requirements document.
- If **NO** (it depends on the old stack) → remove it or generalize it.

## Stratification Rule
Requirements are hierarchical. Stay at the right level for each document:

| Document | Appropriate Level | Example |
|---|---|---|
| **Stakeholder Requirements** | Business / clinical / user needs | "The device shall automate the IFA testing workflow from sample to result." |
| **System Requirements** | What the system must do (still no technology) | "The system shall control motorized microscope axes to position over slide wells." |
| **Software Requirements** | What software must do (begin to specify interfaces) | "The software shall provide a positioning interface that accepts target coordinates." |

**Never** put System Requirements into Stakeholder Requirements, and **never** put implementation details into any requirements document.

## When Reading Existing Documentation

### Recognize Document Types and Use Them Correctly

| Old Document | What It Tells You | What NOT to Extract |
|---|---|---|
| **SAD** (Architecture) | System decomposition, interfaces, data flow, component roles | Architecture decisions, component names, class hierarchies, technology choices |
| **SDD** (Design) | Detailed component behavior, algorithms, state machines | Design patterns, class names, method signatures |
| **SRS / Requirements** | What the product was intended to do | HOW the old implementation achieved it |
| **Test plans** | What was validated, test scenarios | Test procedures, test data |
| **Changelog / Git history** | Feature evolution, bug patterns (what broke) | Version numbers, commit hashes |
| **Source code** | Actual behavior, edge cases, error handling patterns | Code structure, variable names, algorithms |
| **Marketing specs** | User-facing features, clinical claims | Marketing language |

### The "Architecture Trap"
Old documents may be labeled "Architecture" or "Design" but they actually describe **both** WHAT and HOW. When reading a Software Architecture Document:

- ✅ Extract: "The system has three main software components: IFA processing, image capture, and result confirmation."
- ❌ Do NOT extract: "The system shall use Qt 4.8.4 with a DataPool publish-subscribe pattern and SQLite database."

The fact that there ARE three components is a domain decomposition — that's useful. HOW they communicate is an architecture decision — not a requirement.

## Summary Checklist

When extracting requirements from existing products, verify each requirement:

- [ ] Describes a user need, clinical workflow, or business capability?
- [ ] Free of technology names, brands, protocols, buses, file formats?
- [ ] Free of architecture patterns, class names, design decisions?
- [ ] Free of concrete numbers from the old implementation (unless the number is a genuine domain constraint)?
- [ ] Passes the "rewrite from scratch" test?
- [ ] At the appropriate level for the target document (stakeholder vs. system vs. software)?
- [ ] Not simply restating what old code does?
- [ ] Placed in the correct subdirectory: StakeholderReqs → `01_StakeholderReqs/`, SystemReqs → `02_SystemReqs/`, SW Reqs → `03_SoftwareReqs/`, HW Reqs → `04_HardwareReqs/`?

## Anti-Pattern: Wrong Directory

❌ `01_Requirements/StakeholderRequirements.md` (root of requirements — lazy)
✅ `01_Requirements/01_StakeholderReqs/StakeholderRequirements.md` (correct subdirectory)

The directory structure exists for a reason. Each requirements type has its own folder. Respect it.
