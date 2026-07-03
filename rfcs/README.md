# The RFC Process

Every normative change to FrogAI — anything that defines or alters what a
conformant implementation is allowed or required to do — goes through this
process before it becomes part of [`specification/`](../specification/).
This document is itself governed by the amendment rule at the bottom.

If you are unsure whether your change needs an RFC, see the decision table
in [CONTRIBUTING.md](../CONTRIBUTING.md).

## Why RFC-first

A specification that changes based on the last conversation someone had is
not a specification, it is a mood. Requiring a written proposal, a public
discussion window, and an explicit acceptance decision means:

- Every normative rule has a recorded rationale, not just a result.
- Objections are raised and resolved *before* the rule ships, not after
  someone has already built against it.
- Rejected ideas are recorded too — so the same proposal is not re-litigated
  from scratch every time someone new encounters the same tempting shortcut.

## Lifecycle

```
Draft → Discussion → Final Comment Period → Accepted → (implemented in specification/)
                                          ↘ Rejected
Draft/Discussion/FCP → Withdrawn (by author, any time before Accepted)
Accepted → Superseded (by a later RFC that explicitly says so)
```

### 1. Draft

- Copy [`0000-template.md`](./0000-template.md) to
  `rfcs/NNNN-short-title.md`, where `NNNN` is the next unused four-digit
  number (ask the RFC Editor, or check open PRs, to avoid collisions — a
  collision is resolved by whichever RFC merges first keeping the number;
  the other is renumbered).
- Fill in every section of the template. An incomplete template is not a
  valid Draft.
- Open a pull request. The RFC's status (in its own front matter) is
  `Draft`. This README's index table below is updated in the same PR.

### 2. Discussion

- Open for public comment for a **minimum of 10 business days** from the
  pull request being opened.
- The author is expected to respond to substantive objections by revising
  the RFC text itself (not just replying in comments) — the RFC document
  must always reflect the current best version of the proposal, not the
  first draft plus a scattered comment thread.
- Discussion has no maximum duration. An RFC with no maintainer willing to
  move it to FCP after a reasonable time is not being blocked — it simply
  has not yet earned the confidence required for the next step.

### 3. Final Comment Period (FCP)

- Any maintainer may propose moving the RFC to FCP once they believe
  discussion has converged, by commenting on the pull request and updating
  the RFC's status to `Final Comment Period`.
- FCP lasts a **minimum of 10 calendar days**.
- If a maintainer raises a **new, substantive** objection during FCP, the
  RFC returns to `Discussion` and a new FCP must be proposed later — FCP is
  not a rubber stamp.

### 4. Decision

At the end of FCP, per the RFC decision rule in
[GOVERNANCE.md](../GOVERNANCE.md):

- **Accepted** if no maintainer maintains an unresolved, substantive
  objection. The RFC's status is updated to `Accepted`, it is merged, and a
  corresponding `Draft`-status document is created under
  [`specification/`](../specification/) per that directory's README.
- **Rejected** if a maintainer maintains an objection they consider
  blocking, and it has not been resolved. Status is updated to `Rejected`
  with the objection and rationale recorded in the RFC's "Decision" section
  before the PR is closed (not deleted — rejected RFCs remain in history as
  the historical record, listed in the index below).

An Accepted RFC is a **historical record of a decision**, not a live
document — once accepted, an RFC file is not edited again except to add a
`Superseded-by` link. Ongoing evolution happens in the corresponding
`specification/` document, which is versioned independently (see
[`specification/README.md`](../specification/README.md)).

### Withdrawal

The author may withdraw an RFC at any point before it is Accepted by
updating its status to `Withdrawn` and closing the pull request.

### Superseding an Accepted RFC

A later RFC may explicitly propose replacing the normative content of an
earlier Accepted RFC. If the later RFC is accepted, the earlier RFC's status
is updated to `Superseded` with a link to the superseding RFC. The
superseded RFC's text is never deleted or rewritten — history is preserved.

## Roles in this process

See [GOVERNANCE.md](../GOVERNANCE.md) for full role definitions. In summary:
the **RFC Editor** assigns numbers and tracks status/index bookkeeping;
**Maintainers** decide acceptance/rejection and propose FCP; any
**Contributor** may author an RFC.

## RFC index

| # | Title | Status |
|---|---|---|
| [0001](./0001-skill-specification.md) | Skill Specification | Draft |
| [0002](./0002-workflow-specification.md) | Workflow Specification | Draft |
| [0003](./0003-rule-specification.md) | Rule Specification | Draft |
| [0004](./0004-evidence-standard.md) | Evidence Standard | Draft |
| [0005](./0005-verification-standard.md) | Verification Standard | Draft |
| [0006](./0006-memory-standard.md) | Memory Standard | Draft |
| [0007](./0007-benchmark-standard.md) | Benchmark Standard | Draft |
| [0008](./0008-adapter-standard.md) | Adapter Standard | *pending* |

*This table is updated in the same pull request as any RFC status change —
it is the authoritative, at-a-glance index. Links point to files that are
added by their respective RFC pull requests.*

## Amending this process

Changes to this document follow the same rule as [GOVERNANCE.md](../GOVERNANCE.md)'s
amendment process: explicit approval from every current maintainer, plus (while
the project has only a Project Lead) a minimum 5-business-day open comment
period.
