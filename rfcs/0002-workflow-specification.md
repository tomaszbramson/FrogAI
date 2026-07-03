---
rfc: 2
title: Workflow Specification
status: Draft
authors: [tomaszbramson]
created: 2026-07-03
updated: 2026-07-03
supersedes: null
superseded-by: null
---

## Summary

Defines **Workflow**: a versioned document that orchestrates a directed
acyclic graph (DAG) of Skill (RFC-0001) invocations and/or nested Workflows
into a single goal larger than any one Skill covers. A Workflow declares
its steps, the data flowing between them, and failure handling per step; it
does not redefine what a step *does* (that is the referenced Skill's
contract) or *whether it is allowed to run* (that is Rule's, RFC-0003).

## Motivation

A single Skill's contract (RFC-0001 §2) is deliberately narrow — one
postcondition set, one input/output shape. Real engineering tasks ("cut a
release," "migrate a schema," "triage and fix a failing CI run") require
several Skills executed in a specific order, sometimes conditionally,
sometimes in parallel, with one Skill's output feeding another's input.
Today every agent tool encodes this as ad hoc prose ("first do X, then Y")
or a tool-specific automation format, so a multi-step procedure cannot be
ported, its intermediate data flow cannot be checked, and a failure
partway through has no declared, portable recovery semantics. Workflow
exists so composition itself has a contract, independent of any one Skill.

## Terminology

New terms, to be added to [`docs/GLOSSARY.md`](../docs/GLOSSARY.md) when
this RFC is accepted (the existing `Workflow` entry there is superseded by
the normative definition in this RFC's Summary):

- **Workflow Instance** — a specific Workflow document conforming to this
  specification (parallel to Skill Instance in RFC-0001 §1).
- **Step** — one node in a Workflow's graph: a single reference to either a
  Skill or another Workflow, plus its data bindings and failure policy.
- **Workflow Run** — one execution of a Workflow Instance, distinct from
  the Instance (the document) itself — see §4.
- **Data Binding** — a declared mapping from a prior step's `outputs` (or
  the Workflow's own `inputs`) to a step's `inputs`.

## Detailed design

### 1. Workflow Instance format

A Workflow Instance MUST be a single document consisting of a **metadata
block** (front matter, YAML) and an OPTIONAL free-text description body,
mirroring the shape chosen for Skill (RFC-0001 §1) for the same adoption
and consistency reasons.

### 2. Required metadata fields

| Field | Type | Description |
|---|---|---|
| `id` | string | Globally unique within its declaring namespace; stable across versions. See [`specification/conventions/identity.md`](../specification/conventions/identity.md). |
| `version` | string (SemVer) | Version of this Workflow Instance. |
| `name` | string | Short human-readable name. |
| `description` | string | What goal this Workflow accomplishes and when to use it. |
| `status` | enum | `Draft`, `Active`, `Deprecated`, `Retired` — same four-stage lifecycle as Skill (RFC-0001 §4), reused rather than reinvented; see §4 for what is Workflow-specific. |
| `inputs` | list of objects | Same shape as Skill `inputs` (RFC-0001 §2): the Workflow's own external inputs, available to steps as data-binding sources. |
| `outputs` | list of objects | Same shape as Skill `outputs`; each MUST bind to some step's `outputs` (see §3). |
| `steps` | list of Step objects | MUST contain at least one Step. See §3. |

A metadata block missing a required field, or whose `steps` form a graph
that is not a DAG (§3), is not a conformant Workflow Instance; a conformant
implementation MUST refuse to execute it and MUST surface the specific
defect rather than guessing.

### 3. Step object

Each entry in `steps` MUST include:

| Field | Type | Description |
|---|---|---|
| `id` | string | Unique within this Workflow Instance (not globally). |
| `uses` | string | A Skill or Workflow reference: `<id>@<version-constraint>`, where `<version-constraint>` follows [`specification/conventions/version-constraints.md`](../specification/conventions/version-constraints.md). A Workflow `uses` referencing a Workflow (directly or transitively, including itself) forming a cycle is INVALID — implementations MUST detect and reject cyclic composition before execution. |
| `inputs` | map | Data Bindings: each value is either a literal or a reference of the form `${workflow.inputs.<name>}` or `${steps.<step_id>.outputs.<name>}`. A reference to a step not listed in `depends_on` (see below) is INVALID. |
| `depends_on` | list of step `id`s | OPTIONAL, default empty. Declares the edges of the DAG explicitly — an implementation MUST NOT infer edges solely from `inputs` references, to keep ordering auditable independent of data-flow parsing. Any step referenced in an `inputs` binding MUST also appear in `depends_on`. |
| `on_failure` | enum | OPTIONAL, default `abort`. One of `abort` (stop the Workflow Run), `continue` (proceed with independent branches), `retry` (re-attempt per `retry_policy`). |
| `retry_policy` | object | REQUIRED if `on_failure: retry`; MUST include `max_attempts` (integer ≥ 1). A step referencing a Skill with `idempotent: false` (RFC-0001 §2) MUST NOT declare `on_failure: retry`, since a non-idempotent retry risks duplicate side effects. |

Steps with no dependency path between them MAY be executed concurrently by
a conformant implementation; this RFC does not mandate concurrency, only
permits it — a strictly sequential executor that respects `depends_on`
ordering is equally conformant.

Deliberately out of scope for this RFC: conditional branching on a step's
*output value* (as opposed to its success/failure), and a general
expression language for `inputs` bindings beyond the two reference forms
above. See "Unresolved questions."

### 4. Workflow Run state model

A Workflow Instance's `status` (§2) governs the *document*, exactly as for
Skill (RFC-0001 §4) — it is orthogonal to the state of any one **Workflow
Run**. A Workflow Run MUST be represented as one of:

```
Pending → Running → Succeeded
                   ↘ Failed
                   ↘ Cancelled
```

A Run enters `Failed` when a step's `on_failure: abort` fires, or when a
`retry`-policy step exhausts `max_attempts`. A conformant implementation
MUST be able to report, for a `Failed` or `Succeeded` Run, which steps
executed and the postcondition belief (RFC-0001 §6) each produced — this is
the substrate Evidence (RFC-0004) attaches to at the Workflow level.

### 5. Rule interaction

A Workflow does not grant any exemption from Rules (RFC-0003) applicable to
its steps' underlying Skills; a Rule that would block a Skill's direct
invocation blocks it identically when invoked as a Workflow step. This RFC
does not define Rule precedence or scope — that is RFC-0003's normative
content, referenced here only to state that Workflow composition is not a
Rule-bypass mechanism.

## Rationale and alternatives

- **DAG, not arbitrary graph.** Cycles make termination and re-run
  semantics undecidable in general; a DAG guarantees a Workflow Run
  terminates if every step does. A future RFC MAY add bounded, explicit
  looping (e.g. "repeat step until condition") as an additive construct —
  rejected here to keep RFC-0002's first version minimal (Manifesto
  principle 7).
- **Explicit `depends_on`, not inferred from data bindings.** Considered
  deriving the execution graph purely from `${steps...}` references.
  Rejected: it would make a Workflow's execution order a side effect of
  parsing expression strings rather than a direct, reviewable field —
  harder to validate statically and to render as a graph.
- **No embedded expression/scripting language.** Same reasoning as Skill's
  rejection of a declarative execution DSL (RFC-0001, Rationale): two
  reference forms cover the common case (pass Workflow input through, pass
  prior step output forward) without FrogAI having to specify and version
  an expression grammar.
- **Reusing Skill's four-stage lifecycle for `status`**, rather than a
  Workflow-specific one. Rejected inventing a parallel lifecycle: the
  Draft/Active/Deprecated/Retired states mean the same thing for a
  composed procedure as for an atomic one, and a second vocabulary for the
  same concept would violate Manifesto principle 10 (define a term once).

## Backward compatibility

New specification; no prior `Stable` document to break. Once
`specification/core/workflow.md` reaches `Stable`, a change to the Step
object's required fields (§3) is a breaking change requiring a new RFC and
a MAJOR version bump, per `specification/README.md`.

## Security and trust considerations

A Workflow's effective side-effect surface is the union of every step's
Skill's declared `side_effects` (RFC-0001 §2) that can execute given the
DAG's dependency structure — a conformant Adapter or sandbox MUST compute
this union before running a Workflow, not just check each Skill at the
moment its step executes, since a permission decision made mid-Run after
several irreversible steps have already run defeats the purpose of a
pre-execution check. `on_failure: retry` combined with a non-idempotent
Skill is explicitly forbidden (§3) for the same reason: an uncontrolled
retry is an undeclared, potentially duplicated side effect.

## Adoption and migration

Existing orchestration mechanisms (Cursor's multi-step agent prompts,
Claude Code's task lists, CI pipeline YAML) already express step sequencing
informally. Migration is expected to require identifying discrete Skills
within an existing multi-step prose procedure (per RFC-0001's own migration
note) and then expressing their ordering as `steps`/`depends_on`. A
per-tool mapping is deferred to RFC-0008 (Adapter Standard), consistent
with RFC-0001 §"Adoption and migration."

## Unresolved questions

- Should a future revision add conditional branching on step *output
  values* (not just success/failure), and if so, does it need a minimal
  expression grammar this RFC currently avoids? Left open pending
  Draft/Candidate implementation experience.
- Should long-running Workflow Runs support a standard checkpoint/resume
  representation? Candidate for RFC-0006 (Memory Standard) rather than
  this RFC, since resuming is fundamentally a durable-state concern.
- Should `on_failure: continue` require declaring which downstream steps
  are safe to skip versus must still attempt, or is "any step whose
  `depends_on` is unsatisfied is skipped" a sufficient default? Left open.

## Decision record

- **FCP proposed by:** —
- **FCP start/end:** —
- **Outcome:** —
- **Rationale:** —
