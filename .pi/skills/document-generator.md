# Skill: Document Generator

## Purpose
Generate standardized documents from templates using project data.

## Usage
When invoked, this skill:
1. Reads the relevant template from `project/10_Documentation/templates/`
2. Fills in data from project state (`dashboard/data/status.json`) and `dashboard/data/project.json`
3. Generates the document in the appropriate phase directory
4. Updates the document index at `project/10_Documentation/DocumentIndex.md`

## Document Templates Available

### Project Management
- `PMP.md` — Project Management Plan
- `QA_Plan.md` — Quality Assurance Plan
- `CM_Plan.md` — Configuration Management Plan

### Requirements
- `SRS.md` — Software Requirements Specification
- *(StakeholderReqs, SyRS, HardwareReqs — use SRS template adapted)*

### Architecture & Design
- `SW-SAD.md` — Software Architecture Document
- `SDD.md` — Software Design Document
- `ADR.md` — Architecture Decision Record

### Verification & Validation
- `TestPlan.md` — Test Plan
- `ValidationPlan.md` — Validation Plan (OQ/PQ)

### Risk Management
- `FMEA.md` — FMEA Worksheet

## Document Metadata Template
All generated documents include:
```yaml
---
document_id: [ProjectNumber]_[Component]_[DocType]_v[Major].[Minor]
title: "Document Title"
component: [Component]
author: "[Role]"
reviewer: "[Role]"
approver: "[Role]"
status: Draft
version: v00.01
date: YYYY-MM-DD
project: [Project Name]
regulatory: IEC 62304, ISO 14971
---
```

## Generation Process
1. Select template from `project/10_Documentation/templates/`
2. Load current project data from `dashboard/data/status.json`
3. Fill template placeholders (`{PROJECT_NAME}`, `{PROJECT_NUMBER}`, `{COMPONENT}`, etc.)
4. Save to appropriate phase directory
5. Update `project/10_Documentation/DocumentIndex.md`
6. Report generation to dashboard
