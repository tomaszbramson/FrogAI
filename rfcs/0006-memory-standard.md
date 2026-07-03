---
rfc: 6
title: Memory Standard
status: Draft
authors: [tomaszbramson]
created: 2026-07-03
updated: 2026-07-03
supersedes: null
superseded-by: null
---

## Summary

Defines **Memory**: durable, explicitly scoped state an Agent may read or
write across separate Skill executions or Workflow Runs, carrying the
provenance metadata needed to know where a remembered fact came from and
when it stops being trustworthy. Memory is how FrogAI lets an Agent build
on prior work without re-deriving it every time, while keeping every
remembered fact traceable back to what produced it and expirable when it
goes stale.

## Motivation

An Agent that cannot remember anything across sessions re-discovers the
same project conventions, prior decisions, and user preferences every
single invocation — expensive and inconsistent. Every tool that has
addressed this (Claude Code's project memory files, Cursor's stored rules,
Continue's context providers) does so with an untyped, unscoped blob:
there is no way to know whether a remembered fact is still true, which
execution wrote it, or whether it was ever backed by anything more than an
Agent's guess. Memory needs the same provenance discipline Evidence
(RFC-0004) gave to claims, applied to state that outlives a single
execution — otherwise stale or fabricated memory becomes an unreviewable,
silently-compounding source of error.

## Terminology

New terms, to be added to [`docs/GLOSSARY.md`](../docs/GLOSSARY.md) when
this RFC is accepted (the existing `Memory` entry there is superseded by
the normative definition in this RFC's Summary):

- **Memory Record** — one structured, provenance-carrying unit of
  remembered state. Like an Evidence Record (RFC-0004), it is generated at
  runtime rather than authored in advance, and has no Draft/Active
  document lifecycle of its own.
- **Scope** — the durability/visibility tier a Memory Record is written
  at: `session`, `task`, `project`, or `global` (§2).
- **Provenance** — the record of which execution produced a Memory
  Record, and optionally which Evidence justified it.

## Detailed design

### 1. Memory Record shape

A Memory Record MUST be a structured object with:

| Field | Type | Description |
|---|---|---|
| `scope` | enum | `session`, `task`, `project`, or `global` — see §2. |
| `key` | string | Identifies this fact within its scope; unique per `(scope, key)` pair among `active` records. |
| `value` | any | The remembered content. |
| `provenance` | object | `{ produced_by: { id, version, run_id }, evidence_ref? }` — which Skill/Workflow execution wrote this, and OPTIONALLY the Evidence Record (RFC-0004) that justified it. |
| `created_at` | string (ISO 8601) | When this Record was written. |
| `status` | enum | `active`, `superseded`, `invalidated`, or `expired` — see §4. |
| `expires_at` | string (ISO 8601) | OPTIONAL. Absence means the Record does not expire automatically, only by explicit supersession or invalidation. |

A Memory Record asserting a factual claim about the world (as opposed to a
simple preference or configuration value) SHOULD carry `evidence_ref`; a
conformant Agent SHOULD weight evidence-backed Memory over unbacked Memory
when both apply to the same decision, but this RFC does not forbid writing
unbacked Memory — Memory is a substrate for remembering, not itself a
Claim subject to RFC-0004/0005's obligations.

### 2. Scope

| Scope | Durability |
|---|---|
| `session` | Valid only for the lifetime of one Skill execution or Workflow Run; MUST NOT be read by any other execution. |
| `task` | Valid for a bounded unit of work spanning multiple Runs (e.g. one ticket); the boundary is implementation-defined. |
| `project` | Durable for the lifetime of the codebase/repository the Agent operates on. |
| `global` | Durable across projects (e.g. a user's stated preferences). Higher-risk: affects unrelated future work, so an Agent SHOULD apply more scrutiny before writing or trusting `global` Memory than narrower scopes. |

### 3. Read precedence

When a `key` has an `active` Memory Record at more than one applicable
scope, a conformant Agent MUST prefer the narrowest scope
(`session` > `task` > `project` > `global`) — the same
narrower-beats-broader precedence principle RFC-0003 §4 already applies to
Rule specificity, reused here rather than inventing a second precedence
rule for the same shape of problem.

### 4. Record status

```
active → superseded (a newer Record at the same scope+key was written)
active → invalidated (explicitly contradicted; MUST carry a rationale, e.g. via a new evidence_ref)
active → expired (current time has passed expires_at)
```

A conformant Agent MUST NOT treat a `superseded`, `invalidated`, or
`expired` Record as current fact — only the latest `active` Record for a
given `(scope, key)` may be relied upon. Implementations MAY prune
non-`active` Records; if retained, they remain available for audit but not
for decision-making.

### 5. Verification Record retention

This RFC resolves the open question left in RFC-0005 ("Verification
Record retention... left open — leaning toward Memory"): retaining a
Verification Record beyond its originating execution MUST use this Memory
model — typically as a `project`- or `global`-scoped Memory Record with an
implementation-chosen `expires_at` — rather than a bespoke retention
mechanism. This RFC does not mandate a specific retention duration.

## Rationale and alternatives

- **Four scope tiers, not a boolean "session vs. persistent."** Rejected a
  two-tier model: `task` and `project` are genuinely different
  durabilities in practice (a fact scoped to one ticket vs. one repository
  forever), and collapsing them would force every implementation to
  reinvent the distinction informally.
- **Status model with `invalidated` distinct from `expired`.** An
  explicitly contradicted fact (`invalidated`) is a different, more urgent
  signal than one that merely aged out (`expired`) — collapsing them would
  hide cases where something the Agent believed was actively wrong, not
  just stale.
- **No Draft/Active *document* lifecycle for Memory Records**, mirroring
  Evidence's reasoning (RFC-0004, Rationale): a Memory Record is a
  timestamped runtime fact, not an authored reusable document, so
  Skill/Workflow/Rule's four-stage lifecycle does not apply to it — its
  own `status` field (§4) serves the equivalent purpose for runtime facts.
- **`evidence_ref` optional, not required.** Rejected requiring every
  Memory Record to cite Evidence: many legitimate memories (a stated user
  preference, a naming convention someone typed once) are not claims a
  Skill postcondition ever produced Evidence for, and requiring it would
  make ordinary preference-remembering impossible under this standard.

## Backward compatibility

New specification; no prior `Stable` document to break. Once
`specification/standards/memory.md` reaches `Stable`, changing the
required fields in §1, the scope tiers in §2, or the precedence rule in
§3 is a breaking change requiring a new RFC and a MAJOR version bump.

## Security and trust considerations

Memory is a persistence mechanism, which makes it a durable channel for
poisoning: a false fact written once and never invalidated can silently
influence every future execution that reads it. The narrowest-scope-wins
precedence (§3) and mandatory expiration/invalidation states (§4) both
exist to bound this risk — `global` Memory is explicitly called out as
higher-risk precisely because its blast radius is largest. A `blocking`
Rule (RFC-0003) MAY restrict which Skills are permitted to write `global`
Memory using RFC-0001's `side_effects` enum, which includes a `memory-write`
category (RFC-0001 §2).

## Adoption and migration

Existing untyped memory files (Claude Code project memory, Cursor stored
rules used as de facto memory, Continue context providers) map onto
`project`-scoped Memory Records without `evidence_ref`; adoption requires
adding the `scope`/`provenance`/`status` structure this RFC requires
around content that today is unstructured prose. A per-tool mapping is
deferred to RFC-0008 (Adapter Standard).

## Unresolved questions

- ~~RFC-0001's `side_effects` enum (§2) does not yet include a
  `memory-write` category~~ — **Resolved**: RFC-0001 §2 now includes
  `memory-write` in the `side_effects` enum, added as part of this
  foundation-improvement pass. See also
  [`FUTURE-RFC-CANDIDATES.md`](../FUTURE-RFC-CANDIDATES.md), "Already
  resolved."
- Should concurrent writers producing different `value`s for the same
  `(scope, key)` at the same instant have a defined tie-break (e.g.
  last-write-wins by `created_at`), or is this left entirely to
  implementations? Left open.
- Should there be a standard eviction/pruning policy for `session`-scope
  Memory, or is "MUST NOT be read by any other execution" (§2) sufficient
  without mandating when it is physically discarded? Left open.

## Decision record

- **FCP proposed by:** —
- **FCP start/end:** —
- **Outcome:** —
- **Rationale:** —
