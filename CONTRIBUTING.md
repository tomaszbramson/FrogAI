# Contributing to FrogAI

Thank you for considering a contribution. This project is a specification,
so most contributions are documents and words, not code — the review bar
for precision and consistency is correspondingly high. Please read
[MANIFESTO.md](./MANIFESTO.md) before your first contribution; it explains
*why* the process below is as strict as it is.

## What kind of contribution do you have?

| You want to... | Do this |
|---|---|
| Propose a new concept, or change normative behavior | Open an RFC — see [`rfcs/README.md`](./rfcs/README.md) |
| Fix a typo, broken link, or clarify existing (non-normative) wording | Open a pull request directly |
| Report an inconsistency or ambiguity in an existing spec | Open an issue |
| Ask a question | Open a "Question" issue — do not open an RFC to ask a question |
| Propose a governance or process change | Open a pull request against [GOVERNANCE.md](./GOVERNANCE.md) or [`rfcs/README.md`](./rfcs/README.md), per the amendment rules in each |

If you are unsure whether something needs an RFC, open an issue first and
ask. As a rule of thumb: if it changes what a conformant implementation is
allowed or required to do, it needs an RFC.

## Mechanics

### Branch naming

`type/short-description`, where `type` is one of `rfc`, `spec`, `docs`,
`process`, or `fix`. Example: `rfc/0009-testing-taxonomy`,
`docs/glossary-memory-clarification`.

### Commit messages

FrogAI uses [Conventional Commits](https://www.conventionalcommits.org/):

```
<type>(<scope>): <short summary>

<body, if needed>
```

Common types: `docs`, `rfc`, `spec`, `process`, `fix`, `chore`. Scope is the
affected area, e.g. `rfcs`, `specification/core`, `governance`. Example:

```
rfc(0001): propose Skill Specification

Introduces the Skill primitive: contract shape, lifecycle states, and
required metadata fields.
```

### Developer Certificate of Origin (DCO)

Every commit must be signed off (`git commit -s`), certifying you wrote the
contribution or otherwise have the right to submit it under this project's
license (see the [DCO text](https://developercertificate.org/)). Pull
requests with unsigned commits will be asked to amend before merge.

### Pull request content

Every pull request description must state, in its own words:

- **Purpose** — what problem this solves or what it proposes.
- **Architectural reasoning** — why this approach, and what alternatives
  were considered (may reference an RFC instead of repeating it).
- **Future impact** — what this makes easier or harder later, including any
  compatibility implications.
- **Follow-up recommendations** — what should happen next, if anything, as
  a result of this change.

A pull request missing any of these sections will be asked to add it before
review begins — this is not optional formatting, it is how reviewers assess
whether a change belongs in a specification project.

### Scope discipline

One pull request should correspond to one RFC, one specification document,
or one clearly-scoped documentation fix. Do not bundle unrelated changes —
it makes review, and later `git blame` archaeology, unreliable.

## Review and merge

- Non-normative changes (typo fixes, clarifications that do not alter
  meaning): reviewed and merged by any maintainer under lazy consensus
  (5 business days, no objection) per [GOVERNANCE.md](./GOVERNANCE.md).
- RFCs and specification documents: follow the RFC lifecycle in
  [`rfcs/README.md`](./rfcs/README.md), which is the normative process —
  this document does not repeat or override it.
- Governance/process changes: follow the amendment rules stated in
  [GOVERNANCE.md](./GOVERNANCE.md) or [`rfcs/README.md`](./rfcs/README.md)
  respectively.

## Style

- Write specification and RFC text in the normative language of
  [RFC 2119](https://www.ietf.org/rfc/rfc2119.txt) (`MUST`, `MUST NOT`,
  `SHOULD`, `MAY`, etc.) once a document reaches `Draft` status or later —
  see [`specification/README.md`](./specification/README.md).
- Define every term once, in [`docs/GLOSSARY.md`](./docs/GLOSSARY.md), and
  link to it rather than restating the definition.
- Prefer short declarative sentences over long compound ones — a
  specification that requires re-reading to parse is a defect in the
  specification, not a reflection on the reader.

## Code of Conduct

Participation in this project is governed by
[CODE_OF_CONDUCT.md](./CODE_OF_CONDUCT.md).
