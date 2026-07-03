# Version Constraints Convention

Several places in this specification reference another versioned Instance
by `<id>@<version-constraint>` — for example, a Workflow Step's `uses` field
(RFC-0002 §3) and an Adapter Manifest's `profile` field (RFC-0008 §2). This
convention defines the syntax of `<version-constraint>` once, rather than
each RFC inventing or informally implying its own (see
[MANIFESTO.md](../../MANIFESTO.md) principle 10).

## Adopted syntax

A `<version-constraint>` MUST be a valid
[npm Semantic Versioning Range Specification](https://github.com/npm/node-semver#ranges)
(the `node-semver` ranges grammar). This includes, without limitation:

- An exact version: `1.2.3`
- A caret range: `^1.2.3` (compatible within the same MAJOR)
- A tilde range: `~1.2.3` (compatible within the same MINOR)
- A comparator range: `>=1.2.0 <2.0.0`
- The wildcard `*` (any version)

This specification does not redefine or restrict the `node-semver` grammar —
it adopts it in full, so an implementation can validate a
`<version-constraint>` with an existing, widely available library rather
than a bespoke parser.

## Resolution semantics

When more than one `version` of an Instance with a given `id` satisfies a
`<version-constraint>`, a conformant implementation MUST resolve to the
highest satisfying version, consistent with `node-semver`'s own default
resolution behavior. If no published version satisfies the constraint, this
is a resolution failure: a conformant implementation MUST refuse to proceed
and MUST surface the `id` and the unsatisfiable constraint, rather than
silently falling back to an unconstrained version.

## Why not a bespoke grammar

An earlier draft of RFC-0002 left `<version-constraint>` undefined,
implicitly assuming SemVer without stating a comparison grammar. Inventing a
FrogAI-specific range syntax would require every Adapter (RFC-0008) to ship
a custom parser for a grammar with no ecosystem tooling, existing test
suites, or prior art — in tension with Manifesto principle 7
(maintainability over speed). Adopting `node-semver`'s ranges gets a
battle-tested grammar and existing implementations in every major language
for free.

## Relationship to `specification/README.md`'s Versioning section

`specification/README.md`'s "Versioning" section governs how a
*specification document itself* is versioned (`MAJOR.MINOR.PATCH`,
independently per document). This convention governs how an *Instance*
(a Skill, Workflow, Rule, etc. authored against that specification)
references another Instance's `version` field, which also follows SemVer.
The two uses of SemVer are related but distinct: this document is the single
place where the *comparison/range* syntax is defined, applying uniformly to
every RFC that references a version constraint.
