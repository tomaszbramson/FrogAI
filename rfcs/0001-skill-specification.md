---
rfc: 1
title: Skill Specification
status: Draft
authors: [tomaszbramson]
created: 2026-07-03
updated: 2026-07-03
supersedes: null
superseded-by: null
---

## Summary

Defines **Skill**: the atomic, contract-bound unit of Agent capability in
FrogAI. A Skill is a versioned document with a required, machine-readable
metadata block (identity, inputs, outputs, pre/postconditions, declared
side effects) and a natural-language instruction body. It is the smallest
thing FrogAI specifies — Workflows compose Skills (RFC-0002), Rules
constrain them (RFC-0003), and Evidence/Verification (RFC-0004/0005) judge
whether a Skill's execution actually satisfied its contract.

## Motivation

Every agent tool today (Cursor rules, Claude Code skills, Continue rules,
Cline/Roo custom instructions) has independently invented a way to say "the
agent should know how to do X." These formats are incompatible, their
contracts are implicit (a paragraph of prose, not a checkable postcondition),
and there is no shared way to say "this Skill succeeded" other than eyeballing
the diff. Teams cannot: (1) port a Skill between tools without a rewrite,
(2) verify a Skill did what it claimed, or (3) benchmark one Skill
implementation against another. A Skill needs a name, a version, a declared
contract, and a declared set of side effects before any of Evidence,
Verification, Benchmark, or Adapter (RFC-0004–0008) can be specified in
terms of it — this is why Skill is RFC-0001.

## Terminology

Introduces **Skill** (already listed in
[`docs/GLOSSARY.md`](../docs/GLOSSARY.md) as "pending"; this RFC provides
its normative definition) and the following new terms, to be added to the
Glossary when this RFC is accepted:

- **Skill Instance** — a specific Skill document written by a team or tool,
  conforming to this specification (as opposed to the specification
  itself).
- **Side Effect** — any change a Skill may make to state outside its
  return value (filesystem writes, git operations, network calls, package
  installs, Memory writes).
- **Idempotency** — the property that re-running a Skill against the same
  preconditions produces the same postconditions without additional
  unintended side effects.

## Detailed design

### 1. Skill Instance format

A Skill Instance MUST be a single document consisting of:

1. A **metadata block** (front matter) in YAML, containing the required
   fields defined in §2.
2. An **instruction body**: natural-language content the Agent uses to
   understand *how* to perform the Skill. The body is not itself normative
   for conformance checking — conformance is judged against the metadata
   contract (§2) via Evidence/Verification (RFC-0004/0005), never against
   whether the Agent followed the prose a particular way. This deliberately
   leaves room for different models to solve the "how" differently while
   agreeing on the "what."

This mirrors the shape already used by the most widely adopted informal
convention in the ecosystem (frontmatter + Markdown body), which lowers the
adoption cost for existing tools and their Adapters (RFC-0008), while adding
the required structure informal formats lack.

### 2. Required metadata fields

A conformant Skill Instance's metadata block MUST include:

| Field | Type | Description |
|---|---|---|
| `id` | string | Globally unique within its declaring namespace; stable across versions. See [`specification/conventions/identity.md`](../specification/conventions/identity.md) for the full convention, including the RECOMMENDED reverse-DNS-style notation (e.g. `com.example.release.cut-changelog`). |
| `version` | string (SemVer) | Version of this Skill Instance. |
| `name` | string | Short human-readable name. |
| `description` | string | One or two sentences: what this Skill does and when to use it. |
| `status` | enum | One of `Draft`, `Active`, `Deprecated`, `Retired` — see §4. Distinct from, and not to be confused with, the specification document status lifecycle in `specification/README.md`. |
| `inputs` | list of objects | Each with `name`, `type`, `required` (bool), `description`. MAY be empty. |
| `outputs` | list of objects | Each with `name`, `type`, `description`: the structured result the Skill produces, distinct from side effects. |
| `preconditions` | list of strings | Checkable statements that MUST hold before invocation. Implementations MAY, but are not required by this RFC to, check these automatically. |
| `postconditions` | list of strings | Checkable statements that MUST hold after a successful execution. This is the Skill's success contract, and is what Evidence (RFC-0004) is produced against. |
| `side_effects` | list of enum | Zero or more of `filesystem-write`, `vcs-write`, `network`, `package-install`, `external-service`, `memory-write`. MUST list every category of side effect the instruction body can cause; MUST NOT omit one that applies. `memory-write` covers any write of a Memory Record (RFC-0006 §1), independent of `scope` — a Skill writing only `session`-scope Memory still MUST declare it, since scope affects blast radius, not whether a side effect occurred. |
| `idempotent` | boolean | `true` only if re-invocation under unchanged preconditions is safe and produces no additional side effects beyond the first successful run. |

A metadata block missing any required field is not a conformant Skill
Instance. An implementation encountering one MUST refuse to execute it and
MUST surface which field(s) are missing, rather than guessing a default.

### 3. Optional metadata fields

| Field | Type | Description |
|---|---|---|
| `rules` | list of Rule `id`s | Rules (RFC-0003) this Skill explicitly depends on beyond globally-applicable ones. Absence does NOT mean no Rules apply — see RFC-0003 for the default-applicability model. |
| `evidence_requirements` | list of Evidence `type`s (RFC-0004) | Evidence types this Skill's execution MUST produce beyond whatever a Workflow or Verification policy already mandates. |
| `tags` | list of strings | Free-form categorization; not used for conformance. |
| `deprecated_by` | Skill `id` | Set when `status: Deprecated`; points to the replacement Skill Instance. |

### 4. Skill Instance lifecycle

```
Draft → Active → Deprecated → Retired
```

- **Draft** — not yet trusted for autonomous invocation; a conformant Agent
  MAY require explicit human confirmation before executing a `Draft` Skill.
- **Active** — safe for normal invocation subject to any Rules in force.
- **Deprecated** — still executable, MUST carry `deprecated_by`, and a
  conformant Agent SHOULD warn when invoking it.
- **Retired** — MUST NOT be invoked by a conformant Agent; retained only as
  a historical record (e.g. for Evidence produced by past executions).

This lifecycle governs a single Skill Instance file authored by an
implementer team; it is unrelated to, and MUST NOT be conflated with, the
`Draft`/`Candidate`/`Stable`/`Deprecated` status of *this specification
document itself* once RFC-0001 is accepted (see `specification/README.md`).

### 5. Identity and versioning

- `id` MUST be stable across versions of the same Skill Instance — a
  version bump changes `version`, never `id`.
- `version` MUST follow SemVer. A MAJOR bump is REQUIRED whenever
  `inputs`, `outputs`, `preconditions`, or `postconditions` change in a way
  that could invalidate an existing caller's expectations. Adding an
  optional input or a non-behavior-changing side-effect declaration
  correction is a MINOR or PATCH change respectively, at the implementer's
  judgment.

### 6. Execution contract

A conformant Agent invoking a Skill Instance:

1. MUST NOT invoke a Skill whose declared `preconditions` it has reason to
   believe are false, without surfacing that conflict.
2. MUST treat `side_effects` as an exhaustive declaration — an Agent MUST
   NOT perform a side effect of a category not listed in `side_effects`
   while executing that Skill's instruction body.
3. MUST, on completion, be able to state whether it believes each declared
   `postcondition` holds — this belief is what Evidence (RFC-0004) attaches
   to, and what Verification (RFC-0005) checks.
4. MUST NOT silently reinterpret `outputs` — if the instruction body cannot
   produce a declared output, this is a failed execution, not a partial
   success.

## Rationale and alternatives

- **Frontmatter + prose body, not a fully declarative DSL.** A fully
  declarative "do this, then this" language would be more mechanically
  checkable but would either constrain Agents to a rigid execution engine
  (defeating the point of using an LLM-driven Agent at all) or become a
  second programming language FrogAI would then have to specify and
  maintain (violates Manifesto principle 7). The chosen shape keeps the
  *contract* declarative and checkable while leaving the *method* to the
  Agent and model.
- **Alternative rejected: no `side_effects` declaration.** Considered
  letting Verification infer side effects after the fact from Evidence
  alone. Rejected because Adapters (RFC-0008) and sandboxing/permission
  systems need to know *before* execution what a Skill might do, not only
  after — an undeclared side effect is a safety gap, not just an audit gap.
- **Alternative rejected: global Skill versioning (one version number for
  the whole Skill library).** Rejected for the same reason
  `specification/README.md` versions each spec document independently —
  forcing lockstep versioning punishes unrelated Skills for each other's
  changes.

## Backward compatibility

This is a new specification; there is no prior `Stable` document to break.
Once this RFC is accepted and `specification/core/skill.md` reaches
`Stable`, any future change to the required-field table in §2 is a breaking
change requiring a new RFC and a MAJOR version bump, per
`specification/README.md`.

## Security and trust considerations

The `side_effects` and `preconditions` fields exist specifically so that an
Adapter or sandboxing layer can make a permission decision *before*
executing a Skill's instruction body, without needing to parse or trust
free-text prose. `postconditions` is the anchor Evidence (RFC-0004) and
Verification (RFC-0005) attach to — without a declared postcondition, there
is nothing for those standards to check a claim of success against.

## Adoption and migration

Existing informal formats (Cursor `.mdc` rules, Claude Code `SKILL.md`
files, Continue rules, Cline/Roo custom instructions) already use a
frontmatter-plus-body shape informally. Migration is expected to be
additive: existing instruction bodies can typically be kept as-is, with the
required metadata fields in §2 added on top. A per-tool mapping of this
shape onto each tool's native format is the explicit subject of RFC-0008
(Adapter Standard), not this RFC.

## Unresolved questions

- Should `preconditions`/`postconditions` eventually support a structured,
  optionally-machine-checkable expression syntax (beyond free-text
  strings), and if so, is that an RFC-0001 MINOR revision or a separate
  RFC? Left open pending real-world Draft/Candidate implementation
  experience (see `specification/README.md`'s Candidate→Stable gate).
- How does a Skill declare a dependency on *another Skill* being available
  (as opposed to a Workflow explicitly composing them)? Deferred to
  RFC-0002 (Workflow Specification), since composition is a Workflow
  concern by design (§ "Detailed design," Rationale in RFC-0002).

## Decision record

- **FCP proposed by:** —
- **FCP start/end:** —
- **Outcome:** —
- **Rationale:** —
