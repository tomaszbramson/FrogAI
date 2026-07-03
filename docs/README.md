# Documentation

This directory contains **informative** material: explanations, glossaries,
and architectural context that help a reader understand FrogAI. Nothing
here is normative — if a document in [`specification/`](../specification/)
disagrees with something here, the specification wins and this directory
has a bug to fix (see `specification/README.md`, "Relationship to `docs/`").

## Contents

- [`GLOSSARY.md`](./GLOSSARY.md) — the single, canonical definition of every
  term used across FrogAI's RFCs and specifications. Every other document
  links here instead of redefining a term, per
  [MANIFESTO.md](../MANIFESTO.md) principle 10 ("one concept, one
  definition").
- [`ARCHITECTURE.md`](./ARCHITECTURE.md) — how the core objects (Skill,
  Rule, Workflow) and the cross-cutting standards (Evidence, Verification,
  Memory, Benchmark, Adapter) relate to each other as a system.
- [Conventions](../specification/conventions/README.md) — cross-cutting
  shared shapes referenced by multiple specifications.
- [Future RFC Candidates](../FUTURE-RFC-CANDIDATES.md) — topics that may
  (or may not) become RFCs later.

## Adding documentation

Non-normative documentation changes (fixing an unclear explanation, adding
a diagram, expanding the glossary with a term already used elsewhere) do
not require an RFC — see the decision table in
[CONTRIBUTING.md](../CONTRIBUTING.md). They still require a pull request
and are merged under lazy consensus per
[GOVERNANCE.md](../GOVERNANCE.md).

If a documentation change would introduce a *new* term that does not yet
appear in any RFC or specification, prefer defining it in the relevant RFC
first — the Glossary records terms that already have an owner, it does not
mint new ones by itself.
