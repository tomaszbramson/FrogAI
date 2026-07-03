---
rfc: 5
title: Verification Standard
status: Draft
authors: [tomaszbramson]
created: 2026-07-03
updated: 2026-07-03
supersedes: null
superseded-by: null
---

## Summary

Defines **Verification**: the process and set of gates by which the
Evidence (RFC-0004) attached to a Claim is checked for validity before
that Claim is treated as trustworthy. Evidence Standard defines what proof
must look like; this RFC defines who or what checks it, what the possible
outcomes are, and when a Claim may be relied upon downstream (e.g. to
advance a Workflow Run, RFC-0002 §4, or to satisfy a `blocking` Rule,
RFC-0003 §5). Evidence existing is necessary but not sufficient — this RFC
is the "sufficient" half.

## Motivation

RFC-0004 stops at "here is a checkable artifact." Nothing yet says an
Evidence Record was actually *checked*, by whom, or what happens when the
check fails or the evidence turns out to be insufficient. Without this,
"Evidence exists" risks becoming a rubber stamp — an Agent could attach a
Record and treat its own Claim as settled, which is exactly the
unverified-self-report problem Evidence was introduced to solve. A
Verification standard is what actually closes the loop from "the Agent
believes this postcondition holds" (RFC-0001 §6) to "this Claim may be
relied upon."

## Terminology

New terms, to be added to [`docs/GLOSSARY.md`](../docs/GLOSSARY.md) when
this RFC is accepted (the existing `Verification` entry there is
superseded by the normative definition in this RFC's Summary):

- **Verifier** — an entity that produces a Verification Record for a
  Claim: `automated` (a mechanical check), `human` (a person), or `hybrid`
  (an automated check plus required human confirmation).
- **Verification Policy** — a versioned document declaring which
  Verifier(s) are required for Claims within a given scope, and under what
  combination rule.
- **Verification Record** — the structured outcome produced by a Verifier
  for one Claim and its Evidence.
- **Verification Gate** — the point at which a Workflow Run, a Rule
  check, or any other consumer of a Claim blocks on a Verification Record
  before proceeding.

## Detailed design

### 1. Verification Policy format

A Verification Policy MUST be a document with a metadata block containing:

| Field | Type | Description |
|---|---|---|
| `id` | string | Globally unique; stable across versions. See [`specification/conventions/identity.md`](../specification/conventions/identity.md). |
| `version` | string (SemVer) | Version of this Policy. |
| `name` | string | Short human-readable name. |
| `status` | enum | `Draft`, `Active`, `Deprecated`, `Retired` — the same lifecycle reused from RFC-0001/0002/0003, for the same one-vocabulary reason given there. |
| `applies_to` | Scope Selector | Reuses the Scope Selector shape from RFC-0003 §3 (`skills`/`workflows`/`tags`) unchanged, rather than defining a second scoping mechanism — a Policy and a Rule both need to answer "what does this apply to," and RFC-0003 already specifies that answer. |
| `verifiers` | list of Verifier objects | See §2. MUST contain at least one. |
| `mode` | enum | `all` (every listed Verifier MUST return `Pass`) or `any` (at least one MUST return `Pass`). |

### 2. Verifier object

| Field | Type | Description |
|---|---|---|
| `type` | enum | `automated`, `human`, or `hybrid`. |
| `check` | string | REQUIRED if `type: automated` or `hybrid`. An implementation-defined reference to the mechanical check to run (e.g. a test command, a linter rule id) — this RFC does not standardize the check's own execution format, only that a Verification Record must name which `check` produced its outcome. |
| `role` | string | REQUIRED if `type: human` or `hybrid`. A role name (e.g. `maintainer`, `security-reviewer`), not an individual's identity, so a Policy stays portable across teams and does not hardcode a specific person. |

### 3. Verification Record

Produced once per (Claim, Verifier) pair. MUST contain:

| Field | Type | Description |
|---|---|---|
| `claim` | string | The Claim being verified — MUST match an `claim` on a related Evidence Record (RFC-0004 §1). |
| `evidence_refs` | list of string | Identifiers of the Evidence Record(s) this Verifier examined. A Verification Record with an empty `evidence_refs` MUST NOT return `Pass` — see §4. |
| `verifier` | object | `{ type, check or role }`, echoing which Verifier (§2) produced this Record. |
| `outcome` | enum | `Pass`, `Fail`, or `Inconclusive`. See §4. |
| `rationale` | string | REQUIRED if `outcome` is `Fail` or `Inconclusive`; OPTIONAL for `Pass`. |
| `timestamp` | string (ISO 8601) | When this Verification Record was produced. |

### 4. Outcomes and gating

Three outcomes, not two, because "the evidence was checked and is wrong"
and "the evidence was insufficient to tell" are different failure modes a
reviewer needs to distinguish:

- **`Pass`**: the Verifier confirms the Claim holds, based on the
  referenced Evidence. Requires non-empty `evidence_refs` — a Verifier
  MUST NOT `Pass` a Claim with no Evidence to point to, regardless of
  Verifier `type`.
- **`Fail`**: the Verifier determined the Claim does not hold.
- **`Inconclusive`**: the Verifier could not determine either way (e.g.
  the Evidence Record's `type`, RFC-0004 §2, does not actually substantiate
  the specific Claim, or an automated `check` errored rather than ran).

For gating purposes (a Verification Gate, e.g. a Workflow Run step or a
`blocking` Rule check), both `Fail` and `Inconclusive` MUST be treated as
**not verified** — a Claim is only relied upon downstream once every
required Verifier (per the Policy's `mode`) has returned `Pass`.
Distinguishing `Fail` from `Inconclusive` matters for diagnosis and for
routing (a `Fail` calls for fixing the underlying action; an
`Inconclusive` calls for better Evidence or a different Verifier) but does
not change the gate's blocking behavior.

### 5. Interaction with Rule and Workflow

A `blocking` Rule (RFC-0003 §5) with `checkable: automated` or `hybrid`
(RFC-0003 §6) SHOULD have a corresponding Verification Policy scoped to
match it, so the Rule's compliance is actually checked rather than merely
declared checkable. A Workflow Run (RFC-0002 §4) whose step is gated by a
Verification Policy MUST NOT proceed past that step until the gate
resolves per §4; a `Fail` or `Inconclusive` outcome is handled by that
step's `on_failure` policy (RFC-0002 §3) exactly as a Skill execution
failure would be.

## Rationale and alternatives

- **Three outcomes, not a boolean.** Rejected a simple pass/fail: an
  automated check that errors, or evidence that is present but doesn't
  actually address the Claim, is a materially different situation from
  evidence that was checked and contradicts the Claim — collapsing both
  into `Fail` would hide which fix is actually needed.
- **Reusing RFC-0003's Scope Selector**, not a new scoping model. A
  Verification Policy and a Rule both answer "what does this apply to";
  defining a second, slightly different mechanism here would violate the
  same one-concept-one-definition principle already applied when Rule
  reused Skill/Workflow's lifecycle.
- **`role`, not an individual, for human Verifiers.** An individual's
  identity is an organizational detail outside FrogAI's scope (Manifesto:
  model/tool/org-agnostic); `role` keeps a Policy portable across teams
  while still requiring *someone* accountable to sign off.
- **Alternative rejected: letting `Pass` gate on Evidence *existing*
  without inspecting it.** Would make Verification a formality
  indistinguishable from the self-report problem this RFC exists to
  solve — an empty or irrelevant `evidence_refs` MUST NOT `Pass` (§4).

## Backward compatibility

New specification; no prior `Stable` document to break. Once
`specification/standards/verification.md` reaches `Stable`, changing the
required fields in §1–§3 or narrowing the `Fail`/`Inconclusive` gating
behavior in §4 is a breaking change requiring a new RFC and a MAJOR
version bump.

## Security and trust considerations

Verification is the last checkpoint before a Claim is allowed to influence
a downstream decision — merging a change, promoting a Workflow Run,
satisfying a `blocking` Rule. Treating `Inconclusive` as not-verified (§4)
is itself a security property: an ambiguous check must never silently
resolve to trusted just because it wasn't a definite failure. Requiring
non-empty `evidence_refs` for `Pass` prevents a Verifier — automated or
human — from rubber-stamping a Claim with nothing behind it.

## Adoption and migration

Existing CI status checks map onto `automated` Verifiers; existing PR/code
review approval maps onto `human` Verifiers with a `role` such as
`reviewer`; a required-check-plus-required-approval branch protection rule
maps onto a Policy with `mode: all`. A per-tool mapping of Policy
enforcement is deferred to RFC-0008 (Adapter Standard).

## Unresolved questions

- Should a human Verifier be able to override an automated `Fail` (and if
  so, must that override itself produce its own Verification Record with
  a `rationale`)? Left open pending Draft implementation experience.
- How long must Verification Records be retained, and is that a
  Verification concern or a Memory (RFC-0006) concern? Left open —
  leaning toward Memory, since retention is fundamentally a durable-state
  policy.

## Decision record

- **FCP proposed by:** —
- **FCP start/end:** —
- **Outcome:** —
- **Rationale:** —
