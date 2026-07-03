# Governance

This document defines who can make what kind of decision in FrogAI, and how
those roles change over time. It exists so that disputes and succession are
resolved by a pre-agreed process, not by whoever is loudest at the time —
see [MANIFESTO.md](./MANIFESTO.md) principle 12.

## Roles

### Maintainer

Has merge rights on the repository and voting rights on RFC acceptance (see
[`rfcs/README.md`](./rfcs/README.md)). Maintainers are accountable for the
technical quality and internal consistency of the specification as a whole,
not just the RFCs they personally author.

**Becoming a maintainer:** nominated by an existing maintainer, based on a
sustained record of high-quality RFC contributions or reviews, and
confirmed by consensus (see Decision-Making below) of the existing
maintainer group. There is no fixed contribution count or tenure
requirement — the bar is demonstrated judgment on specification quality.

### RFC Editor

A maintainer (or, before the project has multiple maintainers, the Project
Lead) responsible for process integrity: assigning RFC numbers, tracking
status transitions in the RFC index, and ensuring the discussion/FCP
timelines in [`rfcs/README.md`](./rfcs/README.md) are followed. The RFC
Editor does not have unilateral authority to accept or reject an RFC on
technical grounds — that is a maintainer decision.

### Project Lead

Until the project has an active maintainer group of three or more, the
Project Lead (currently the repository's original author) holds the
decision authority described under Maintainer above, and additionally has
tie-breaking authority described below. This role is intended to be
**temporary by design**: see "Transition out of a single Project Lead"
below.

### Contributor

Anyone who opens an issue, RFC, or pull request. No approval is required to
become a Contributor — it is the default role for participation.

## Decision-making

### RFC acceptance

Governed entirely by the process in [`rfcs/README.md`](./rfcs/README.md).
In summary: an RFC needs no sustained, unresolved maintainer objection at
the end of its Final Comment Period to be accepted. This document does not
duplicate that process — see the RFC document for the normative version.

### Everything else (non-RFC decisions)

Day-to-day decisions that do not change the specification — repository
structure, tooling, process clarifications, this document itself — are
made by **lazy consensus** among maintainers: a proposal is adopted if no
maintainer objects within 5 business days of it being posted as a pull
request or issue. Any maintainer may escalate a lazy-consensus item to a
full vote by objecting before the window closes.

### Ties and deadlocks

If maintainers are evenly split on a decision after reasonable discussion:

- While a Project Lead exists, the Project Lead breaks the tie.
- Once the project has transitioned to a maintainer group with no Project
  Lead (see below), a deadlock is resolved by a scheduled re-vote after a
  mandatory 5-business-day cooling-off period. If the deadlock persists, the
  proposal is considered rejected — FrogAI treats "no changed consensus" as
  a signal that the proposal is not yet ready, consistent with Manifesto
  principle 7 (maintainability over speed).

## Neutrality

No maintainer may hold a governance role in FrogAI on behalf of, or under
direction from, a specific model provider or agent-tool vendor in a way
that would bias RFC decisions toward that vendor's implementation. A
maintainer's employer is disclosed on request but is not, by itself,
disqualifying — the constraint is on conduct (voting to bias the spec
toward one implementation), not employment. Concerns should be raised
following [CODE_OF_CONDUCT.md](./CODE_OF_CONDUCT.md).

## Transition out of a single Project Lead

The Project Lead role exists to bootstrap the project, not to be permanent.
Once three or more Maintainers (excluding the Project Lead) have been
confirmed per the process above, the Project Lead must open an RFC-style
proposal (following the amendment process below) to either:

1. Dissolve the Project Lead tie-breaking authority in favor of the
   deadlock process described above, or
2. Explicitly renew it with a stated reason and a re-review date no more
   than 12 months out.

This obligation is itself a governance rule and is subject to the same
lazy-consensus override as any other maintainer, precisely so the Project
Lead cannot unilaterally decline to hold the review.

## Amending this document

Changes to GOVERNANCE.md are proposed as a normal pull request, but require
**explicit approval from every current maintainer** (not lazy consensus) —
governance changes are exactly the category of decision this project does
not want to slide through by default. While only a Project Lead and no
other maintainers exist, an amendment additionally requires a minimum
5-business-day open comment period before merging, so the absence of other
maintainers cannot be used to change the rules without notice.
