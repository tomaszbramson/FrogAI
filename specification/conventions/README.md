# Cross-cutting Conventions

This directory holds conventions that apply identically across every Level 1
primitive (Skill, Workflow, Rule) and every Level 2 standard (Evidence,
Verification, Memory, Benchmark) rather than being redefined, slightly
differently, inside each RFC. It exists so that "how does `id` work" or "what
counts as a valid version constraint" has exactly one normative answer,
consistent with [MANIFESTO.md](../../MANIFESTO.md) principle 10 (one concept,
one definition).

A convention document here is normative in the same sense as any other
document under [`specification/`](../README.md) — see that document's
"Front matter contract" and "Versioning" sections, which apply here
unchanged. A convention is referenced by the RFCs and specification
documents that depend on it; it does not stand alone as a primitive of its
own.

## Contents

- [`identity.md`](./identity.md) — the `id` field: global uniqueness,
  recommended notation, and stability across versions.
- [`version-constraints.md`](./version-constraints.md) — the syntax used
  wherever a document references another by `<id>@<version-constraint>`.
- [`conformance.md`](./conformance.md) — the normative meaning of
  "Conformant Implementation," referenced by every RFC's use of `MUST` /
  `MUST NOT`.

## Relationship to Levels 1–4

Conventions sit alongside Level 0 ([`specification/README.md`](../README.md)):
they are meta-rules about how every other level is written, not a level of
their own. A Level 1–4 document MUST NOT restate a convention's content
inline — it MUST link to the relevant file here instead, per the same
one-concept-one-definition principle that governs [`docs/GLOSSARY.md`](../../docs/GLOSSARY.md).

## Adding a new convention

A new convention that changes what a conformant implementation is allowed or
required to do follows the normal RFC process
([`rfcs/README.md`](../../rfcs/README.md)). A convention document that is
purely descriptive of an already-agreed practice may land via the
non-normative documentation path in
[CONTRIBUTING.md](../../CONTRIBUTING.md) instead.
