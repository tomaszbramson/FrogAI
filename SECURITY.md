# Security Policy

FrogAI is a specification, not a running service — there is no deployed
software here to exploit directly. "Security" in this repository means a
**specification-level vulnerability**: a defect in a normative document that,
if implemented as written, would let a Conformant Implementation
(see [`specification/conventions/conformance.md`](./specification/conventions/conformance.md))
silently behave less safely than the specification's own stated intent —
for example:

- A gap that lets a `blocking` Rule (RFC-0003 §5) be bypassed or silently
  dropped without violating any single `MUST` statement in isolation.
- An Adapter fail-closed requirement (RFC-0008 §4–§5) that has an
  unspecified edge case where an implementation could plausibly, and
  conformantly, fail open instead.
- An ambiguity in `side_effects` (RFC-0001 §2), Evidence (RFC-0004), or
  Verification (RFC-0005) that would let an unverified or undeclared action
  appear substantiated or authorized.
- A Memory (RFC-0006) scoping or precedence defect that could let a
  narrower-scoped actor read or influence a broader scope than intended.

Ordinary editorial issues (typos, unclear prose, broken links) are **not**
security reports — open a normal issue or pull request per
[CONTRIBUTING.md](./CONTRIBUTING.md) instead.

## Reporting a specification-level vulnerability

Please **do not** open a public issue or pull request for a suspected
specification-level vulnerability until it has been reviewed privately —
public disclosure before a fix or mitigating clarification is drafted could
let existing Adapters be exploited against the gap before it's addressed.

To report:

1. Open a private security advisory on this repository (GitHub's
   "Report a vulnerability" flow under the Security tab), if available to
   you.
2. If you cannot use that flow, contact the Project Lead or a Maintainer
   listed in [GOVERNANCE.md](./GOVERNANCE.md) directly.

Include:

- Which RFC or `specification/` document is affected, and the specific
  section/field.
- The concrete scenario in which a Conformant Implementation could exhibit
  the unsafe behavior.
- Any suggested wording fix, if you have one (not required).

## Response process

- **Acknowledgment**: a maintainer will acknowledge a report within 5
  business days.
- **Assessment**: the maintainer group determines whether the report
  describes a genuine specification-level gap (as opposed to expected,
  documented behavior) and its severity.
- **Resolution**: a confirmed vulnerability is resolved the same way any
  normative change is made — as an RFC (if it changes required behavior) or
  a lazy-consensus documentation clarification (if it only closes an
  ambiguity without changing intent), per
  [`rfcs/README.md`](./rfcs/README.md) and
  [CONTRIBUTING.md](./CONTRIBUTING.md). Coordinated disclosure timing (when
  to make the report and fix public) is decided case-by-case with the
  reporter, favoring prompt disclosure once a fix is available.

## Scope

This policy covers the normative content of this repository
(`rfcs/`, `specification/`). It does not cover the security posture of any
specific tool's Adapter implementation — report those to that tool's own
project.
