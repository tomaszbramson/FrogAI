# Conformance Convention

Every RFC in this project uses `MUST`, `MUST NOT`, `SHOULD`, `SHOULD NOT`,
`MAY`, and `REQUIRED` in the normative sense of
[RFC 2119](https://www.ietf.org/rfc/rfc2119.txt), clarified by
[RFC 8174](https://www.ietf.org/rfc/rfc8174.txt) (which resolves RFC 2119's
ambiguity about lower-case usage of these terms: only the upper-case forms
carry normative weight). This convention defines what it means for an
implementation to *be* conformant, once, rather than each RFC restating the
definition (see [MANIFESTO.md](../../MANIFESTO.md) principle 10). The
Glossary's "Conformance" and "Conformant Implementation" entries point here
for the normative text.

## Definition

A **Conformant Implementation**, with respect to a given specification
document or Profile (`specification/README.md` Level 4), is an Agent,
Adapter, or tool that:

1. Satisfies every `MUST` and `MUST NOT` statement in that document for
   every case the statement applies to — partial or best-effort compliance
   with a `MUST` does not qualify.
2. Refuses to execute, load, or otherwise act on an Instance that violates a
   `MUST`/`MUST NOT` constraint it is responsible for checking, and surfaces
   the specific violation, rather than silently ignoring, approximating, or
   guessing a resolution. This "fail-closed" posture is already required
   piecemeal by individual RFCs (e.g. RFC-0001 §2 on a missing required
   field, RFC-0008 §4 on an unsupported field) — this convention states it
   once as the general rule those are instances of.
3. Is permitted, but never required, to additionally satisfy `SHOULD` /
   `SHOULD NOT` recommendations; declining a `SHOULD` does not forfeit
   conformance, but MAY be asked to be justified in review.
4. Treats an unrecognized or malformed input to a required field as a
   conformance failure of the *input*, not license to interpret it
   permissively — an implementation MUST reject malformed input rather than
   coerce it into a best guess.

## Partial conformance

Some documents (notably Adapter Manifests, RFC-0008 §2's `capabilities` map)
explicitly define a graded, per-primitive conformance model (`full`,
`partial`, `none`). Where such a document defines its own grading, that
grading is authoritative for that document; this convention's binary
definition above is the default that applies wherever a document does not
define a finer-grained alternative.

## Relationship to a Profile

Claiming conformance to a Profile (`specification/README.md` Level 4) means
satisfying this definition independently against every Level 1–3 document
the Profile pins, at the exact versions the Profile names — conformance does
not average or partially satisfy across the bundled documents.
