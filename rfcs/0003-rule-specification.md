---
rfc: 3
title: Rule Specification
status: Draft
authors: [tomaszbramson]
created: 2026-07-03
updated: 2026-07-03
supersedes: null
superseded-by: null
---

## Summary

Defines **Rule**: a versioned document declaring a constraint on Agent
behavior that holds independently of any single task — true or forbidden
regardless of which Skill (RFC-0001) or Workflow (RFC-0002) is currently
executing. A Rule declares its scope (what it applies to), its
enforcement level (blocking or advisory), and, where possible, how
compliance can be checked. Rules do not describe *how* to accomplish a
goal (that is Skill/Workflow); they describe what must always, or never,
happen while any goal is being accomplished.

## Motivation

RFC-0001 §3 already assumes Rules exist ("Rules this Skill explicitly
depends on beyond globally-applicable ones") without defining what a Rule
is, how it decides what it applies to, or what happens when two Rules
disagree. Every agent tool today has some equivalent (Cursor's `.mdc`
`alwaysApply` rules, Claude Code's project instructions, Continue's rules)
but each invents its own scoping and precedence model, none of them
portable, and none machine-checkable for conflicts. Without a Rule
specification, "the Agent must never force-push to `main`" is unenforceable
prose repeated per tool instead of one portable, precedence-ordered
constraint that composes predictably with every Skill and Workflow.

## Terminology

New terms, to be added to [`docs/GLOSSARY.md`](../docs/GLOSSARY.md) when
this RFC is accepted (the existing `Rule` entry there is superseded by the
normative definition in this RFC's Summary):

- **Rule Instance** — a specific Rule document conforming to this
  specification (parallel to Skill Instance, RFC-0001 §1).
- **Scope Selector** — the part of a Rule's metadata declaring which
  Skills, Workflows, or everything, the Rule applies to.
- **Enforcement Level** — whether a Rule's violation MUST block execution
  (`blocking`) or only be surfaced (`advisory`).
- **Rule Conflict** — two or more applicable Rules whose constraints cannot
  simultaneously be satisfied for a given action.

## Detailed design

### 1. Rule Instance format

A Rule Instance MUST be a single document with a **metadata block** (front
matter, YAML) and an OPTIONAL free-text rationale body, mirroring Skill
(RFC-0001 §1) and Workflow (RFC-0002 §1) for the same consistency reasons.

### 2. Required metadata fields

| Field | Type | Description |
|---|---|---|
| `id` | string | Globally unique within its declaring namespace; stable across versions. See [`specification/conventions/identity.md`](../specification/conventions/identity.md). |
| `version` | string (SemVer) | Version of this Rule Instance. |
| `name` | string | Short human-readable name. |
| `statement` | string | A single, checkable sentence using an RFC 2119 keyword (`MUST`, `MUST NOT`, `SHOULD`, `SHOULD NOT`) — this is the Rule's entire normative content. Free prose beyond this belongs in the body, not here. |
| `status` | enum | `Draft`, `Active`, `Deprecated`, `Retired` — the same document lifecycle reused from Skill (RFC-0001 §4) and Workflow (RFC-0002 §2), for the reason given there: one lifecycle vocabulary, not a third one. |
| `applies_to` | Scope Selector | See §3. Absence of a matching, more specific Rule does NOT mean no Rule applies — see §4. |
| `level` | enum | `blocking` or `advisory`. See §5. |

### 3. Scope Selector

`applies_to` is an object with any combination of:

| Field | Type | Description |
|---|---|---|
| `skills` | list of string | Skill `id` patterns (exact id, or `id@*` for all versions, or `*` for all Skills). |
| `workflows` | list of string | Same pattern forms, for Workflow `id`s. |
| `tags` | list of string | Matches any Skill/Workflow whose own `tags` (RFC-0001 §3) intersect this list. |

Omitting a field means "no constraint from this dimension," not "matches
nothing" — a Rule with `applies_to: {}` (all fields omitted or empty)
matches every Skill and every Workflow, i.e. it is **globally applicable**.
This is why RFC-0001 §3's `rules` field on a Skill is explicitly additive:
a Skill's applicable Rules are the union of (a) every globally-applicable
Rule, (b) every Rule whose Scope Selector matches that Skill's `id` or
`tags`, and (c) every Rule explicitly listed in the Skill's own `rules`
field — never a replacement for (a) or (b).

### 4. Default applicability and precedence

When more than one applicable Rule's `statement` bears on the same action,
a conformant Agent MUST resolve precedence as follows, in order:

1. **Specificity**: a Rule scoped to a specific `skills`/`workflows` `id`
   outranks one scoped by `tags`, which outranks one that is globally
   applicable (`applies_to: {}`).
2. **Enforcement level**: at equal specificity, `blocking` outranks
   `advisory`.
3. **Explicit `priority`** (OPTIONAL integer metadata field, default `0`,
   higher wins), if steps 1–2 leave a tie.

If two `blocking` Rules at equal specificity, level, and `priority` produce
contradictory requirements for the same action (a Rule Conflict), a
conformant Agent MUST NOT silently pick one — it MUST treat this as if the
action were blocked, and surface the conflicting Rule `id`s. Fail-closed on
conflict is deliberate: guessing which safety constraint to honor is worse
than refusing to act.

### 5. Enforcement levels

- **`blocking`**: a conformant Agent MUST NOT take an action it has reason
  to believe violates this Rule's `statement`. This applies identically
  whether the action originates from direct invocation or from a Workflow
  step (RFC-0002 §5) — Workflow composition is never a Rule bypass.
- **`advisory`**: a conformant Agent MUST surface the Rule when an action
  may violate it, but MAY proceed.

### 6. Checkability (optional)

| Field | Type | Description |
|---|---|---|
| `checkable` | enum | OPTIONAL, one of `automated`, `manual`, `hybrid`. Declares whether compliance with `statement` can be mechanically checked at all, partially, or only by human/Agent judgment. Absence means `manual`. |

This RFC does not define *how* an automated check is performed — that is
Verification's concern (RFC-0005). `checkable` exists so a Rule Instance
can declare its own checkability honestly rather than implying a guarantee
this specification does not make.

## Rationale and alternatives

- **A Rule is one `statement`, not a list.** Considered allowing multiple
  statements per Rule Instance. Rejected: precedence (§4) and conflict
  detection require comparing individual constraints; bundling several
  into one document would force them to share a single `level` and
  `applies_to`, hiding cases where they should differ.
- **Fail-closed on Rule Conflict, not "last one wins" or authoring order.**
  An order-dependent resolution is not portable across implementations
  that may load Rules in a different order, and would silently favor
  whichever Rule happens to be evaluated last — the opposite of an
  auditable precedence model.
- **Specificity-then-level-then-priority, not priority alone.** Considered
  a single `priority` integer as the sole precedence signal. Rejected: it
  would let a low-effort, broadly-scoped Rule silently override a
  narrowly-targeted one just by setting a high number, undermining the
  principle that a more specific constraint should be harder to
  accidentally overrule.
- **`checkable` is declarative, not a guarantee.** Rejected requiring every
  Rule to be automatically checkable — many real constraints ("MUST NOT
  introduce a misleading commit message") are not mechanically decidable,
  and requiring it would exclude legitimate Rules rather than improve
  safety.

## Backward compatibility

New specification; no prior `Stable` document to break. Once
`specification/core/rule.md` reaches `Stable`, a change to the required
fields in §2 or the precedence order in §4 is a breaking change requiring a
new RFC and a MAJOR version bump, per `specification/README.md`.

## Security and trust considerations

Rule is FrogAI's primary safety-constraint primitive: `blocking` Rules are
what an Adapter or sandbox consults, alongside a Skill's declared
`side_effects` (RFC-0001 §2) and a Workflow's aggregated side-effect union
(RFC-0002, Security section), before permitting an action. The fail-closed
Rule Conflict behavior (§4) is itself a security property — an Agent that
resolved conflicting blocking constraints by guessing would be less safe
than one that refuses to act.

## Adoption and migration

Existing "always apply" instruction mechanisms (Cursor `alwaysApply`
rules, Claude Code project-level instructions, Continue rules) map onto a
globally-applicable, `blocking` or `advisory` Rule Instance with
`applies_to: {}`. Existing scoped/glob-based rule mechanisms map onto a
Scope Selector (§3). A per-tool mapping is deferred to RFC-0008 (Adapter
Standard), consistent with RFC-0001 and RFC-0002's own migration sections.

## Unresolved questions

- Should `applies_to` eventually support excluding specific Skills/Workflows
  from an otherwise-global Rule (a negative selector), or is composing
  narrower, higher-precedence Rules (§4) sufficient? Left open pending
  Draft/Candidate implementation experience.
- Should Rule Conflict detection be required to run statically (before any
  action is attempted) rather than only at the moment of the conflicting
  action? Left open — likely a Verification (RFC-0005) concern.

## Decision record

- **FCP proposed by:** —
- **FCP start/end:** —
- **Outcome:** —
- **Rationale:** —
