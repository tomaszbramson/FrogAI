---
rfc: NNNN
title: <Short, descriptive title>
status: Draft
authors: [<name or handle>]
created: <YYYY-MM-DD>
updated: <YYYY-MM-DD>
supersedes: null
superseded-by: null
---

<!--
This is the RFC template. Copy this file to `rfcs/NNNN-short-title.md` and
fill in every section — see `rfcs/README.md` for the process this document
is used in. Do not delete a section; write "N/A" with a one-line reason if
it genuinely does not apply. An RFC that skips a section without explanation
will be asked to add it before Discussion begins.
-->

## Summary

One paragraph. If a reader stops after this section, they should still know
what is being proposed and why it matters.

## Motivation

What problem does this solve? Who is affected by not having it? Reference
concrete scenarios, not hypotheticals — if you can point to an existing
FrogAI document, agent tool behavior, or user report that motivates this,
do so. This section justifies *why the project should spend its scarcity
budget* (maintenance burden, spec surface area, review time) on this
proposal — see Manifesto principle 7.

## Terminology

Define any new term this RFC introduces. Do not redefine a term that
already has an entry in [`docs/GLOSSARY.md`](../docs/GLOSSARY.md) — if this
RFC needs to change an existing definition, say so explicitly here and
explain why, since that is itself a breaking change to every document that
relies on the old definition.

## Detailed design

The normative core of the RFC. Write this section as if it will be copied,
nearly verbatim, into the resulting `specification/` document — because it
will be. Use [RFC 2119](https://www.ietf.org/rfc/rfc2119.txt) keywords
(`MUST`, `MUST NOT`, `SHOULD`, `MAY`, `REQUIRED`, `RECOMMENDED`, `OPTIONAL`)
precisely and consistently. Cover, at minimum:

- The shape/schema of any new object or field.
- Required vs. optional elements, and default behavior when optional
  elements are absent.
- Interaction with existing primitives (Skill, Rule, Workflow, Evidence,
  Verification, Memory, Benchmark, Adapter) — be explicit about what does
  *not* change, not just what does.
- Error/failure semantics: what a conformant implementation must do when
  given invalid input.

## Rationale and alternatives

- Why this design, specifically, over the alternatives considered?
- What alternative designs were rejected, and why? (Do not omit
  alternatives that seem obvious in hindsight — future readers benefit from
  knowing they were considered and rejected, not just that they weren't
  chosen.)
- What is the impact of *not* doing this?

## Backward compatibility

- Does this RFC introduce a breaking change to any `Stable` or `Candidate`
  specification document? If so, per [`specification/README.md`](../specification/README.md),
  this MUST be called out here explicitly, including the proposed migration
  path and version bump.
- If this RFC only adds new, optional capability, state that explicitly —
  "no breaking changes" is a claim that needs to be justified, not assumed.

## Security and trust considerations

Does this proposal affect what an agent can do, what it must prove before a
claim is trusted, or what it retains across sessions? If this RFC touches
Evidence, Verification, or Memory concerns even tangentially, say so and
explain how. If genuinely not applicable, state why.

## Adoption and migration

How would an existing implementation (Adapter, tool, or team's Skill/Rule
library) adopt this? Is there a mechanical migration, or does it require
judgment calls? If this depends on another RFC that has not yet been
accepted, name it explicitly.

## Unresolved questions

Open questions that do not block acceptance but should be tracked. It is
acceptable, and expected, for this section to be non-empty — an RFC does
not need to have every downstream question answered to be accepted, only
every question that would change its normative core.

## Decision record

*Filled in by the RFC Editor/maintainers when the RFC leaves Draft status —
left empty at proposal time.*

- **FCP proposed by:** —
- **FCP start/end:** —
- **Outcome:** —
- **Rationale:** —
