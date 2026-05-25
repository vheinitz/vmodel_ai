# Benchmark prompt — drive the V-Model pipeline from a product spec

You are running on a V-Model XT template clone. Read `PI_CONTEXT.md` first
if you have not loaded it yet.

A single product-spec input file has been written to the project. Its path
is passed to you by the orchestrator, but you can also find it as the only
file under `project/01_Requirements/00_UserNeeds/` whose name is **not**
`STK-*.md`. Conventional location:

```
project/01_Requirements/00_UserNeeds/UserNeeds.md
```

That file contains two blocks:

1. A **stakeholder narrative** (free prose, in a fenced code block). This is
   how the customer would describe the device.
2. A **structured specification** (YAML in a fenced code block) with a
   `user_needs_specification:` root, a `device_name`, a
   `high_level_description`, and a `user_needs:` list of entries each
   carrying `id: UN-XX` and `statement: "..."`.

The narrative and the YAML may disagree in places (the narrative might
mention a need that the YAML omits, or vice versa). Use both as input.
The YAML is the authoritative *list* of user needs; the narrative gives
you tone, priorities and operational context.

## Goal of this run

Drive the V-Model **requirements pipeline** forward end-to-end:

1. **Stakeholder needs (STK-NNN)** — for every `UN-XX` in the YAML, create a
   matching `project/01_Requirements/00_UserNeeds/STK-NNN.md` artifact with
   full frontmatter per `.pi/rules/artifact-frontmatter.md`. Map `UN-01` →
   `STK-001`, `UN-02` → `STK-002`, etc. The original `id: UN-XX` string is
   informational only; the V-Model artifact id is the `STK-NNN` filename.
   Use the YAML `statement` as the basis of the artifact body; enrich with
   context from the narrative (priority, approver role, rationale). Do not
   delete or modify the input UserNeeds.md file.

2. **System Requirements (REQ-SYS-NNN)** — for each STK (or coherent group
   of STKs) derive at least one system requirement. Place each in its own
   file under `project/01_Requirements/02_SystemReqs/`. Every REQ-SYS must
   list its STK source(s) in `source:`.

3. **Risk analysis (FMEA-NNN)** — for every safety-relevant flow visible in
   the user needs (e.g. spills, contamination, electrical hazards), draft an
   FMEA entry under `project/08_RiskManagement/`. Reference the controlling
   requirements in `controls:` and the related requirements in
   `related_requirements:`.

4. **Software Requirements (REQ-SW-AC-NNN)** — derive software-level
   requirements that realise the system requirements. Use component code
   `AC` unless the user-needs text clearly suggests a different component.
   Place under `project/01_Requirements/03_SoftwareReqs/AC/`.

5. **Test cases (TC-…)** — for each baselined requirement, draft at least
   one test case in `project/06_Verification/01_UnitTests/`,
   `02_IntegrationTests/`, or `03_SystemTests/` as appropriate. Use
   `verifies: [REQ-…]` and, where applicable, `mitigates: [FMEA-…]`.

**Stop after step 5.** Do not generate architecture, design, source code,
or any artifact outside requirements + risk + verification. Those layers
are out of scope for this benchmark.

## Hard rules (validator-enforced)

- Every artifact lives in its own file. Filename = `<id>.md`.
- Use the frontmatter schema in `.pi/rules/artifact-frontmatter.md`. The
  validator will reject any artifact that omits required keys or uses
  vocabulary outside the closed lists.
- Cross-reference by `id` only. No prose links.
- After every batch you write, run `make validate` and fix all errors
  before moving on.
- A baselined requirement must have `tests: [...]` non-empty. A baselined
  safety requirement must additionally have `risks: [...]` non-empty and
  `safety_class: A|B|C`.

## Quality bar (what the benchmark measures)

The harness will measure your output on these axes; optimise for them:

- **Coverage.** Every UN-XX from the YAML ends up as a STK artifact;
  every STK is the `source` of at least one REQ-SYS; every baselined
  REQ-SYS has at least one test; every safety requirement has at least
  one FMEA.
- **Cleanliness.** `make validate` exits with zero errors at the end.
- **G2 readiness.** `make gates` reports
  `G2_requirements_baselined: READY` — i.e. you moved enough artifacts to
  `status: baselined` to satisfy the gate.
- **Determinism.** This same input may be fed to you multiple times.
  Produce stable artifact ids and consistent derivations so two runs on
  identical input look similar.

## How to start

1. Read `examples/coag-analyzer/` once for the target artifact format.
2. Read `project/01_Requirements/00_UserNeeds/UserNeeds.md` end to end —
   both blocks.
3. Plan the STK → REQ-SYS → FMEA → REQ-SW → TC derivation before writing.
4. Produce each layer in turn; after each, run `make validate` and fix
   any error before moving on.
5. Finally, `make gates` and confirm G2 READY.

Stop when G2 is READY and the validator is clean, or when no further
useful artifact can be derived from the input. Padding (empty or
duplicate artifacts) will lower the coverage and similarity scores.
