# The FrogAI Specification

This directory contains the **normative** documents of FrogAI: the actual,
binding definitions an implementation (agent, Adapter, tool) must follow to
claim conformance. Nothing is added here except as the direct result of an
Accepted RFC — see [`rfcs/README.md`](../rfcs/README.md). If you are looking
for the reasoning behind a specification, read its originating RFC; this
directory holds the living, versioned result of that decision, not the
discussion that produced it.

At the time of writing, this directory is a skeleton: the hierarchy and
rules below are defined so that the RFCs in [`rfcs/`](../rfcs/) have a
well-defined place to land. No document below has been populated yet — see
[ROADMAP.md](../ROADMAP.md) Phase 1 onward.

## Hierarchy

Specifications are organized into four levels. Higher levels may depend on
and reference lower levels; a lower level never depends on a higher one —
this keeps the dependency graph acyclic and each level independently
comprehensible.

```
specification/
├── README.md          Level 0 — this document: the meta-specification
├── conventions/        Level 0 — cross-cutting conventions shared by every level below
│   ├── identity.md
│   ├── version-constraints.md
│   └── conformance.md
├── core/               Level 1 — the primitives an agent is instructed with
│   ├── skill.md
│   ├── workflow.md
│   └── rule.md
├── standards/          Level 2 — cross-cutting concerns over Level 1 objects
│   ├── evidence.md
│   ├── verification.md
│   ├── memory.md
│   └── benchmark.md
├── adapters/           Level 3 — per-tool bindings of Levels 1–2
│   └── <tool>.md        e.g. claude-code.md, cursor.md, continue.md
└── profiles/            Level 4 — named, versioned bundles for conformance
    └── <profile>.md
```

### Level 0 — Meta-specification

This document. Defines the hierarchy, the status lifecycle, and the
versioning rules that every other level must follow. Changes to Level 0
follow the same amendment rule as [`rfcs/README.md`](../rfcs/README.md).

### Cross-cutting Conventions

[`conventions/`](./conventions/README.md) holds Level 0 rules that every
level below must follow identically — e.g. the shape of an `id` field or the
version-constraint syntax used in a reference like `<id>@<version-constraint>`
— defined once instead of restated, with minor drift, inside each RFC (see
[MANIFESTO.md](../MANIFESTO.md) principle 10). A Level 1–4 document MUST
link to the relevant convention rather than restating its content.

### Level 1 — Core Object Specifications

Define **Skill**, **Workflow**, and **Rule** — the primitives an agent
consumes directly. These are the highest-traffic, highest-stability
documents in the project: everything else either constrains them
(Level 2), implements them for a specific tool (Level 3), or bundles them
for conformance claims (Level 4). Produced by RFC-0001–0003.

### Level 2 — Cross-Cutting Standards

Define **Evidence**, **Verification**, **Memory**, and **Benchmark** — how
claims made under Level 1 objects are substantiated, checked, retained, and
measured. A Level 2 document may reference any Level 1 object but never
requires a specific Level 3 Adapter or Level 4 Profile. Produced by
RFC-0004–0007.

### Level 3 — Adapter Specifications

Define how a Level 1/2-conformant Skill, Rule, Workflow, or Evidence trail
maps onto a *specific* tool's native configuration and runtime (e.g.
Continue, Claude Code, Codex CLI, Cline, Roo, Cursor). Each tool gets its
own document. Governed by the general contract in RFC-0008 (Adapter
Standard); individual per-tool Adapter documents may be proposed by
separate, smaller RFCs once RFC-0008 is accepted, and are expected to be
maintained collaboratively with (though not necessarily by) that tool's
own community.

### Level 4 — Profiles

A **Profile** is a named, versioned bundle of specific version numbers from
Levels 1–3 that an implementation can claim conformance to as a single
unit — e.g. "FrogAI Core Profile 1.0" might pin `skill@1.2`, `rule@1.0`,
`workflow@1.1`. Profiles exist so that "we support FrogAI" is a checkable,
unambiguous claim instead of a vague assertion about an unspecified subset
of documents. See [ROADMAP.md](../ROADMAP.md) Phase 5.

## Status lifecycle

Every specification document declares a `status` in its front matter,
independently of every other document's status:

| Status | Meaning |
|---|---|
| `Draft` | Just accepted via RFC. Normative, but may still change without a new RFC if the change is a clarification that does not alter conformant behavior (tracked in the document's changelog). |
| `Candidate` | Believed complete and stable. Requires at least one real (non-reference) implementation attempt before promotion to `Stable` — see the Adoption section of the originating RFC. |
| `Stable` | Breaking changes require a new RFC and a major version bump (see Versioning). Non-breaking clarifications still require a lazy-consensus PR per [GOVERNANCE.md](../GOVERNANCE.md). |
| `Deprecated` | Superseded by a newer document or version. Remains published, with a link to its replacement, for at least one full major-version cycle of whatever depends on it. |

A document only reaches `Draft` through the RFC process. Promotion from
`Draft → Candidate → Stable` does not itself require a new RFC — it
requires a maintainer lazy-consensus decision recorded in the document's
changelog, since no normative behavior changes at a promotion, only the
confidence level attached to it. Any change that *does* alter normative
behavior always requires an RFC, regardless of current status.

## Versioning

Each specification document is versioned independently using
[Semantic Versioning](https://semver.org/): `MAJOR.MINOR.PATCH` in its
front matter.

- **MAJOR** — breaking change to conformant behavior. Always requires an
  Accepted RFC.
- **MINOR** — backward-compatible addition (new optional field, new
  allowed value). Requires an Accepted RFC if it changes what the document
  requires implementations to support; may be a lazy-consensus PR if it is
  purely additive documentation.
- **PATCH** — editorial fix that changes no normative meaning (typo,
  formatting, broken link). Lazy-consensus PR, no RFC required.

Documents do **not** share a single project-wide version number — a change
to the Skill Specification does not bump the version of the Rule
Specification. This mirrors how Kubernetes API groups and OpenAPI
components version independently, and avoids forcing unrelated documents
into lockstep releases.

## Front matter contract

Every document under this directory MUST begin with front matter containing
at least: `status`, `version`, `rfc` (the originating RFC number), and
`updated` (date of last substantive change). This is enforced by review,
not tooling, until [ROADMAP.md](../ROADMAP.md) Phase 5 introduces a
conformance/lint suite.

## Relationship to `docs/`

[`docs/`](../docs/README.md) contains **informative** material — glossary,
architecture explanation, rationale summaries — that helps a reader
understand this directory. It is never normative. If `docs/` and a document
in `specification/` disagree, `specification/` is authoritative and the
discrepancy in `docs/` is a bug to fix, not a nuance to interpret.
