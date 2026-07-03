---
rfc: 7
title: Benchmark Standard
status: Draft
authors: [tomaszbramson]
created: 2026-07-03
updated: 2026-07-03
supersedes: null
superseded-by: null
---

## Summary

Defines **Benchmark**: a reproducible measurement procedure and scoring
method for evaluating a Skill (RFC-0001), Workflow (RFC-0002), or Agent
implementation against a defined set of tasks, such that two independent
runs by different implementers converge within a stated tolerance. A
Benchmark Suite reuses Verification (RFC-0005) to decide whether each task
passed, rather than inventing a second pass/fail mechanism — Benchmark
adds repeatability, scoring, and cross-implementation comparability on top
of a judgment FrogAI already knows how to make.

## Motivation

FrogAI's other RFCs let one execution prove it did what it claimed
(Evidence/Verification), but say nothing about comparing *capability*
across implementations: is Adapter A's mapping of a Skill onto Cursor as
reliable as Adapter B's mapping onto Claude Code? Did a change to a Skill
Instance's instruction body make it more or less likely to satisfy its own
postconditions? Existing agent benchmarks (SWE-bench and similar) answer
this for whole coding agents but have no notion of a FrogAI Skill/Workflow
as the unit under test, and no shared way to say two runs' scores are
comparable rather than artifacts of different scoring code. Benchmark
exists so capability claims about Skills, Workflows, and Agents are
measured the same way Evidence/Verification make single-execution claims
checkable.

## Terminology

New terms, to be added to [`docs/GLOSSARY.md`](../docs/GLOSSARY.md) when
this RFC is accepted (the existing `Benchmark` entry there is superseded
by the normative definition in this RFC's Summary):

- **Benchmark Suite** — a versioned document declaring a target, a set of
  Benchmark Tasks, and a scoring method.
- **Benchmark Task** — one task within a Suite: a setup, an invocation,
  and the postconditions/Rules a Verification Policy will check.
- **Benchmark Run** — one execution of a Suite against a specific subject
  (a Skill, Workflow, or Agent implementation).
- **Metric** — a named, unit-bearing measurement (e.g. latency, cost,
  pass rate) a Suite reports per task and/or in aggregate.

## Detailed design

### 1. Benchmark Suite format

A Benchmark Suite MUST be a document with a metadata block containing:

| Field | Type | Description |
|---|---|---|
| `id` | string | Globally unique; stable across versions. See [`specification/conventions/identity.md`](../specification/conventions/identity.md). |
| `version` | string (SemVer) | Version of this Suite. |
| `name` | string | Short human-readable name. |
| `status` | enum | `Draft`, `Active`, `Deprecated`, `Retired` — the same lifecycle reused from RFC-0001/0002/0003/0005. |
| `target` | enum | `skill`, `workflow`, or `agent` — what kind of subject this Suite measures. |
| `tasks` | list of Benchmark Task objects | MUST contain at least one. See §2. |
| `metrics` | list of Metric objects | See §3. MUST include at least one metric of type `pass-rate` (see §3), so every Suite has a comparable baseline metric even if it also reports others. |
| `runs_per_task` | integer | MUST be ≥ 1. The minimum number of independent repetitions of each task a Benchmark Run MUST perform — see §4 on reproducibility. |

### 2. Benchmark Task

Each entry in `tasks` MUST include:

| Field | Type | Description |
|---|---|---|
| `id` | string | Unique within this Suite. |
| `setup` | object | Fixture/preconditions the task requires before invocation (e.g. a starting repository state), in a shape appropriate to `target`. |
| `invocation` | object | The Skill/Workflow `id@version-constraint` and `inputs` to invoke (matching RFC-0001 §2 / RFC-0002 §2 shapes), or, for `target: agent`, a task prompt. |
| `verification_policy` | Verification Policy reference (RFC-0005 §1) | The Policy that determines whether this task's execution passed. Benchmark MUST NOT define its own bespoke pass/fail logic — a task "passes" exactly when its Verification Record's `outcome` is `Pass` (RFC-0005 §4). |

### 3. Metrics

| Field | Type | Description |
|---|---|---|
| `name` | string | e.g. `pass-rate`, `latency`, `cost`, `step-count`. |
| `type` | enum | `pass-rate` (fraction of task repetitions with a `Pass` Verification outcome) or `measurement` (any other numeric metric). |
| `unit` | string | REQUIRED for `type: measurement` (e.g. `seconds`, `usd`, `tokens`). |
| `aggregation` | enum | `mean`, `median`, or `sum` — how per-repetition values combine into a per-task, and per-task into a per-Suite, value. REQUIRED for `type: measurement`. |

### 4. Reproducibility and tolerance

A Benchmark Run MUST execute each task at least `runs_per_task` times
independently. A Benchmark Report (§5) MUST include, per metric, enough
repetition-level data (not just a single aggregate number) that a second
implementer's independent Benchmark Run can be compared against it. Two
Benchmark Runs of the same Suite version against the same subject version
are considered **convergent** when every reported metric's aggregate value
falls within that metric's declared `tolerance` (an OPTIONAL field on the
Metric object; absence means no tolerance claim is made and Runs are
reported but not asserted comparable). This RFC does not mandate exact
reproducibility — LLM-driven Agents are not deterministic — only a stated,
checkable tolerance.

### 5. Benchmark Report

The output of one Benchmark Run MUST be a structured object with:

| Field | Type | Description |
|---|---|---|
| `suite` | string | `id@version` of the Suite run. |
| `subject` | object | `{ id, version }` of the Skill/Workflow benchmarked, or an implementation-defined Agent/Adapter identifier for `target: agent`. |
| `results` | list | Per task: `{ task_id, verification_record_refs, metric_values }`, where `verification_record_refs` point to the Verification Records (RFC-0005 §3) produced by each repetition. |
| `aggregate` | map | Per-metric aggregate value across all tasks, computed per that Metric's `aggregation`. |
| `timestamp` | string (ISO 8601) | When the Run completed. |

## Rationale and alternatives

- **Verification decides pass/fail, not a Benchmark-specific check.**
  Rejected letting a Suite define its own scoring logic for correctness:
  duplicating Verification's Pass/Fail/Inconclusive model (RFC-0005 §4)
  inside Benchmark would let a Suite silently apply a looser or
  inconsistent bar than the same postcondition would be held to in normal
  operation.
- **Multiple Metrics, not a single scalar score.** A single number cannot
  represent both "did it work" and "how much did it cost" without hiding
  a trade-off a reader needs to see; requiring at least one `pass-rate`
  metric keeps every Suite minimally comparable while not forcing
  everything else into that one number.
- **Tolerance, not exact-match reproducibility.** Rejected requiring
  identical results across runs: an LLM-driven Agent's outputs are not
  bitwise reproducible even holding everything else constant, so a
  reproducibility bar based on exact equality would make every real
  Benchmark Suite non-conformant by construction.
- **Reusing the Draft/Active/Deprecated/Retired lifecycle** for Suite
  `status`, consistent with every other versioned document type in
  FrogAI so far.

## Backward compatibility

New specification; no prior `Stable` document to break. Once
`specification/standards/benchmark.md` reaches `Stable`, changing the
required fields in §1–§2 or the pass/fail-via-Verification requirement in
§2 is a breaking change requiring a new RFC and a MAJOR version bump.

## Security and trust considerations

A Benchmark Report is a capability measurement, not a live Claim about a
specific real-world action — it MUST NOT be used as a substitute
Verification outcome (RFC-0005) for an unrelated execution's Claim, and a
`blocking` Rule (RFC-0003) MUST NOT be satisfied by citing a Benchmark
Report in place of that execution's own Evidence and Verification Record.
Conflating "this Skill scored well on a Suite" with "this specific
execution's postcondition holds" would undermine the per-execution
accountability Evidence and Verification exist to provide.

## Adoption and migration

Existing coding-agent benchmarks (e.g. SWE-bench-style suites) map onto a
`target: agent` Suite whose Tasks wrap each existing test case's setup and
expected outcome as a `verification_policy`. Migrating a benchmark that
currently hand-rolls pass/fail logic requires expressing that logic as a
Verification Policy (RFC-0005 §1) instead. FrogAI does not publish or
mandate any specific Benchmark Suite itself — this RFC standardizes the
format, not the content, of a Suite.

## Unresolved questions

- Should Metric normalization across differing hardware/infrastructure
  (for `latency`/`cost` metrics) be part of this standard, or left
  entirely to the Suite author? Left open.
- Should there be a canonical, FrogAI-maintained reference Suite (distinct
  from third-party Suites using this format), and if so, is that an RFC or
  a separate project artifact? Left open — leaning toward out of scope for
  the specification itself.

## Decision record

- **FCP proposed by:** —
- **FCP start/end:** —
- **Outcome:** —
- **Rationale:** —
