---
rfc: 4
title: Evidence Standard
status: Draft
authors: [tomaszbramson]
created: 2026-07-03
updated: 2026-07-03
supersedes: null
superseded-by: null
---

## Summary

Defines **Evidence**: a structured, verifiable record substantiating a
specific claim an Agent makes about the outcome of an action — sufficient
for an independent reviewer (human or automated) to check the claim
without re-running the original session. Where Skill (RFC-0001 §6) says an
Agent "MUST, on completion, be able to state whether it believes each
declared postcondition holds," this RFC defines the artifact that belief
must be backed by, so a claim of success is never just the Agent's own
say-so.

## Motivation

Every agent tool today lets an Agent report "done" with nothing more than
a natural-language summary of what it believes it did. A reviewer must
either trust that summary or re-derive the truth themselves (re-reading
the whole diff, re-running the whole test suite) — which defeats the
purpose of delegating the work. Skill's postconditions (RFC-0001 §2) and a
Workflow Run's per-step outcomes (RFC-0002 §4) already give FrogAI
something to attach proof to; without an Evidence standard, "attach proof"
has no defined shape, so two Agents' claims of success remain no more
comparable, or independently checkable, than free text.

## Terminology

New terms, to be added to [`docs/GLOSSARY.md`](../docs/GLOSSARY.md) when
this RFC is accepted (the existing `Evidence` entry there is superseded by
the normative definition in this RFC's Summary):

- **Claim** — a specific, falsifiable statement an Agent asserts is true
  about the outcome of an action (typically the text of a Skill
  `postcondition`, RFC-0001 §2, or a Rule `statement`, RFC-0003 §2).
- **Evidence Record** — one structured artifact substantiating exactly one
  Claim. Unlike Skill/Workflow/Rule, an Evidence Record is *generated at
  execution time*, not authored in advance — it has no independent
  Draft/Active lifecycle of its own.
- **Evidence Bundle** — the ordered collection of every Evidence Record
  produced during one Skill execution or Workflow Run.
- **Independent verification** — checking a Claim using only its Evidence
  Record(s), without needing to trust the Agent's summary or re-execute
  the original action.

## Detailed design

### 1. Evidence Record shape

An Evidence Record MUST be a structured object (not a prose document) with
the following required fields:

| Field | Type | Description |
|---|---|---|
| `claim` | string | The exact Claim text being substantiated — SHOULD be copied verbatim from the relevant `postcondition` (RFC-0001) or Rule `statement` (RFC-0003) it corresponds to. |
| `type` | enum | See §2. |
| `content` OR `content_ref` | string | Exactly one of these MUST be present. `content`: the artifact inlined directly. `content_ref`: a URI pointing to the artifact, for large or externally-stored evidence (e.g. a full CI log). |
| `produced_by` | object | `{ id, version, run_id, step_id? }` — which Skill or Workflow Instance (and, for a Workflow, which step) produced this Evidence. |
| `timestamp` | string (ISO 8601) | When the Evidence was produced. |

If `content_ref` is used, the Evidence Record MUST also include an
`integrity` field: `{ algorithm, hash }`, computed over the referenced
artifact at production time, so a reviewer can detect if the referenced
content has since changed or become unavailable-but-silently-replaced.
`integrity` is OPTIONAL, but RECOMMENDED, when `content` is used inline.

### 2. Evidence types

| Type | Sufficiency requirement |
|---|---|
| `diff` | MUST include enough surrounding context to show the change is what it claims to be, not just the changed lines in isolation. |
| `test-run` | MUST include which tests ran, pass/fail counts, and enough output to identify failures by name — not just an aggregate "N passed." |
| `log-excerpt` | MUST include enough surrounding lines to be unambiguous about what produced the excerpted output. |
| `command-output` | MUST include the exact command invoked and its exit status, alongside stdout/stderr. |
| `citation` | MUST include an exact, resolvable locator (URL, file path + line range, or document + section) — not a paraphrase. |
| `external-reference` | A pointer to evidence that exists in a system FrogAI does not control (e.g. a CI provider's own run page). MUST include enough identifying detail (run ID, timestamp) that the referenced system's own record can be located later even if the link itself later breaks. |
| `screenshot` | MUST be accompanied by a text `claim` precise enough that the image is confirmatory, not the sole carrier of meaning (screenshots are not machine-checkable). |

This list is extensible: a new `type` value MAY be introduced by a future
RFC or Adapter-level convention without requiring a MAJOR version bump to
this RFC, provided it satisfies §1's required fields.

### 3. Claim–Evidence obligation

A conformant Agent MUST NOT assert that a Skill `postcondition` (RFC-0001
§2) or a Rule `statement` (RFC-0003 §2) it was responsible for checking
holds, without at least one associated Evidence Record for that exact
Claim. An assertion made without a corresponding Evidence Record is a
nonconformant claim, independent of whether the underlying action actually
succeeded — this standard governs the *shape of the proof*, not the
truth of the underlying action, which is Verification's concern
(RFC-0005).

A Skill's `evidence_requirements` field (RFC-0001 §3), when present,
constrains which `type`s (§2) are acceptable for that Skill's
postconditions; in its absence, any `type` from §2 that genuinely
substantiates the Claim is acceptable.

### 4. Evidence Bundles and Workflow aggregation

All Evidence Records produced during one Skill execution, or one Workflow
Run (RFC-0002 §4), form that execution's Evidence Bundle. A Workflow Run
does not require a distinct Workflow-level Evidence type: its Bundle MUST
be the union of its steps' individual Evidence Records, each still
carrying its own `produced_by.step_id` — this keeps a single Evidence
Record traceable to exactly one Skill's Claim even inside a large,
multi-step Run, rather than requiring a second, coarser evidence format at
the Workflow layer.

## Rationale and alternatives

- **`content` or `content_ref`, not `content` only.** Rejected requiring
  every Evidence Record to inline its artifact: some evidence (a full CI
  run's log, a large test report) is impractically large to inline and
  may already live durably in another system. `content_ref` plus
  `integrity` gets independent verifiability without forcing duplication.
- **A typed enum for `type`, extensible rather than closed.** A closed
  enum would force a new RFC for every evidence shape a real tool
  produces; an unconstrained free-text type would make Skill's
  `evidence_requirements` (RFC-0001 §3) unable to meaningfully constrain
  anything. The extensible-list compromise lets Adapters (RFC-0008)
  introduce tool-specific types without waiting on this RFC.
- **No Evidence Record lifecycle (Draft/Active/etc.).** Rejected reusing
  Skill/Workflow/Rule's four-stage lifecycle here: that lifecycle governs
  an *authored, reusable document*; an Evidence Record is a one-time,
  timestamped fact about a specific execution and is never itself revised
  or deprecated — only ever superseded by a newer execution's own Bundle.
- **Alternative rejected: a single Workflow-level "did it work" Evidence
  Record.** Would lose per-step traceability and make it impossible to
  tell which step's Claim a piece of evidence actually supports —
  contradicts the "independent verification" goal in the Summary.

## Backward compatibility

New specification; no prior `Stable` document to break. Once
`specification/standards/evidence.md` reaches `Stable`, removing a
required field from §1, or narrowing §2's sufficiency requirements for an
existing `type`, is a breaking change requiring a new RFC and a MAJOR
version bump. Adding a new `type` value is additive and does not require a
MAJOR bump, per §2.

## Security and trust considerations

Evidence is deliberately **not** self-certifying: this RFC defines what an
Evidence Record must contain to be checkable, not that its Claim is true —
that judgment belongs to Verification (RFC-0005). `integrity` hashes on
`content_ref` evidence exist specifically so that Verification (or a human
reviewer) can detect post-hoc tampering or silent substitution of
externally-stored evidence, which would otherwise let a false Claim appear
substantiated by content that no longer matches what was originally
produced.

## Adoption and migration

Existing ad hoc "here's what I did" summaries do not map cleanly onto
Evidence Records, since they typically lack a `claim`-to-artifact binding
at all; adoption requires an Agent implementation to start attaching
structured Evidence Records at the point it currently only emits prose.
Existing CI/test-runner output already resembles `test-run` and
`log-excerpt` content and needs only the wrapping metadata in §1 added. A
per-tool mapping is deferred to RFC-0008 (Adapter Standard).

## Unresolved questions

- Should `content_ref` be required to use content-addressable storage
  (e.g. a hash-based URI) rather than a plain location URI plus separate
  `integrity` field? Left open pending real-world Draft implementation
  experience.
- Should there be a standard, signable envelope format for an entire
  Evidence Bundle (e.g. for supply-chain-style attestation), or is that a
  future RFC building on this one? Left open — likely out of scope for
  Evidence's first version.

## Decision record

- **FCP proposed by:** —
- **FCP start/end:** —
- **Outcome:** —
- **Rationale:** —
