# V-Model XT — Agent Benchmark Harness

Synthetic-input harness to measure how completely and consistently a pi-agent
drives the V-Model pipeline forward when given a fictive set of user needs.

## What this is

> **For pi-agent use.** A human can run these scripts, but they are designed
> to be executed by an AI agent. The agent generates fictive input data on a
> throwaway branch, drives the V-Model pipeline, and records measurements
> outside the repo so the template stays clean.

The harness answers two questions:

1. **Coverage** — given N user needs as input, how many downstream artifacts
   (system reqs, software reqs, FMEA entries, test cases) does the agent
   produce? How many validation errors? Is gate G2 ready?
2. **Consistency** — when the same input is fed to the agent multiple times,
   how stable are the results? Mean, standard deviation, coefficient of
   variation, set similarity of produced artifact IDs.

## Layout

```
.pi/benchmark/
├── README.md                  -- this file
├── prompts/
│   └── v-model-pipeline.md    -- the prompt sent to pi
├── scenarios/
│   ├── size-10.json           -- 10 user needs
│   ├── size-20.json           -- 20 user needs
│   ├── size-50.json           -- 50 user needs
│   ├── size-100.json          -- 100 user needs
│   └── size-1000.json         -- 1000 user needs (stress)
└── scripts/
    ├── gen-userneeds.py       -- deterministic STK-* generator
    ├── measure-artifacts.py   -- project-state snapshot (counts, validation, gates, trace coverage)
    ├── compare-runs.py        -- aggregate multiple runs into stats
    └── run-benchmark.sh       -- orchestrator: branch -> generate -> pi -> measure -> save
```

## Workflow (per run)

`run-benchmark.sh` enforces the template-purity contract:

1. **Refuse to run on a dirty working tree.** Fictive input never lands on
   `master`.
2. **Create a disposable branch** named `benchmark/<scenario>-run-<id>-<ts>`.
3. **Generate input** with `gen-userneeds.py` into
   `project/01_Requirements/00_UserNeeds/STK-*.md`. Reproducible from
   `(scenario, run-id)` seed.
4. **Snapshot baseline** with `measure-artifacts.py`.
5. **Invoke the agent** with the prompt at `prompts/v-model-pipeline.md`. The
   default invocation is `pi "$(cat prompts/v-model-pipeline.md)"`. Override
   with `PI_CMD` if your invocation differs.
6. **Snapshot final state** with `measure-artifacts.py`.
7. **Write results** to `$BENCHMARK_RESULTS_DIR` (default
   `~/.cache/vmodel-benchmark/<repo-slug>/<scenario>/`). One JSON file per
   run, named `run-<id>-<ts>.json`.
8. **Return to `master`.** The test branch is left in place for inspection
   (see "After a run").

## Results location (outside the repo on purpose)

Results live at `$BENCHMARK_RESULTS_DIR`, by default
`~/.cache/vmodel-benchmark/<repo-slug>/<scenario>/`.

This is deliberate: benchmark runs accumulate across many short-lived test
branches, so committing them would either pollute master or be lost when the
branch is deleted. Putting them under `~/.cache/` keeps them available for
`compare-runs.py` regardless of branch lifecycle.

If you want to archive a comparison, redirect `compare-runs.py --emit-json`
into a path of your choice.

## Comparing runs

```
python3 .pi/benchmark/scripts/compare-runs.py --scenario size-50
```

Reads every `run-*.json` under the scenario's results directory and prints:

- Per-metric mean ± stddev ± coefficient of variation
- Pass rate (e.g. how many runs reached G2 ready)
- Jaccard similarity of produced artifact-ID sets between run pairs
- Validation error histogram

If the agent is deterministic, CV is near zero. The wider the spread, the
more variability the agent exhibits on identical input.

## After a run

The test branch is left at `benchmark/<scenario>-run-<id>-<ts>`. To clean up:

```
git branch -D benchmark/<scenario>-run-<id>-<ts>
```

To inspect what the agent produced:

```
git checkout benchmark/<scenario>-run-<id>-<ts>
ls project/01_Requirements/02_SystemReqs/   # what agent generated
git checkout master                          # back to template
```

**Never merge a benchmark branch back to master** — that would pollute the
template with fictive product data.

## Make targets

```
make benchmark SCENARIO=size-50           # one run, scenario size-50
make benchmark SCENARIO=size-50 RUN_ID=2  # explicit run id
make benchmark-compare SCENARIO=size-50   # aggregate stats across all runs
make benchmark-list                       # list available scenarios
```

## Agent-agnostic

These scripts only assume:

- A POSIX shell (`bash`)
- Python 3.8+, stdlib only
- An agent CLI named `pi` that takes a prompt string as its first argument and
  blocks until done. Override with `PI_CMD="<your command>"`.
- Git.

No vendor SDKs, no Claude-Code-specific tooling.
