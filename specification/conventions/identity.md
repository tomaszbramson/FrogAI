# Identity Convention

Every versioned FrogAI document type — Skill (RFC-0001), Workflow (RFC-0002),
Rule (RFC-0003), Verification Policy (RFC-0005), Benchmark Suite (RFC-0007),
and Adapter Manifest (RFC-0008) — declares an `id` field in its required
metadata. This convention defines what that field means, once, instead of
each RFC restating a slightly different version of the same requirement (see
[MANIFESTO.md](../../MANIFESTO.md) principle 10).

## Requirements

1. **Global uniqueness.** An `id` MUST be unique within its declaring
   namespace, and MUST NOT collide with the `id` of any other Instance of the
   same primitive type. This specification does not mandate a single global
   registry; namespace collision avoidance is the authoring team's
   responsibility, which is why reverse-DNS notation (below) is RECOMMENDED
   rather than merely suggested.
2. **Stability across versions.** An `id` MUST remain constant across every
   `version` of the same Instance. A version bump changes `version`, never
   `id`. Introducing a new `id` for what is conceptually a new version of an
   existing Instance is, by definition, publishing a different Instance, not
   versioning the original one.
3. **Opacity.** A conformant implementation MUST treat `id` as an opaque
   string for equality comparison. It MUST NOT parse structure out of an `id`
   (e.g. assuming reverse-DNS segments carry meaning) to make a conformance
   or execution decision — the RECOMMENDED notation below is a naming
   convention for humans avoiding collisions, not a machine-readable schema.

## Recommended notation

An `id` SHOULD use reverse-DNS-style notation, e.g.
`com.example.release.cut-changelog`, mirroring the convention already used
informally for Java packages and Android application IDs. This is a
RECOMMENDATION, not a requirement: this specification does not mandate any
particular `id` structure, only the properties in "Requirements" above. An
implementation MUST NOT reject an otherwise-conformant Instance solely for
using a different notation.

## Relationship to specification document versioning

This convention governs the `id` field on an *Instance* of a primitive
(a specific Skill, Workflow, Rule, etc. authored by a team or tool). It is
unrelated to, and MUST NOT be conflated with, the independent versioning of
the *specification documents themselves* under
[`specification/`](../README.md) (see that document's "Versioning" section),
which have no `id` field of their own — they are identified by their file
path and the RFC that produced them.
