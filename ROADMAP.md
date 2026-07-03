# Roadmap

This roadmap describes phases, not deadlines. A phase is considered complete
when its exit criteria are met, not when a calendar date arrives — see
[MANIFESTO.md](./MANIFESTO.md) principle 7 (maintainability over speed).
Each phase builds on documents accepted in the previous one; nothing skips
the RFC process described in [`rfcs/README.md`](./rfcs/README.md).

## Phase 0 — Foundation *(current)*

Establish how the project makes decisions before it makes any technical
commitments.

- [x] Repository skeleton: README, MANIFESTO, VISION, ROADMAP, GOVERNANCE,
      CONTRIBUTING, CODE_OF_CONDUCT, LICENSE.
- [x] RFC process defined ([`rfcs/README.md`](./rfcs/README.md)).
- [x] Specification hierarchy defined
      ([`specification/README.md`](./specification/README.md)).
- **Exit criteria:** a contributor with no prior context can read this
  README and the RFC process and understand exactly how to propose a
  change, with no undocumented steps.

## Phase 1 — Core Object Specifications

Define the three primitives an agent is actually instructed with.

- [ ] RFC-0001: Skill Specification
- [ ] RFC-0002: Workflow Specification
- [ ] RFC-0003: Rule Specification
- **Exit criteria:** all three RFCs accepted and published as `Draft`
  specification documents under `specification/core/`, with a worked
  example referenced (not embedded — see Manifesto principle 9) showing
  how a Skill, a Rule, and a Workflow reference each other consistently.

## Phase 2 — Trust and Accountability Standards

Define how claims made by agents operating under Phase 1 primitives are
substantiated and checked.

- [ ] RFC-0004: Evidence Standard
- [ ] RFC-0005: Verification Standard
- [ ] RFC-0006: Memory Standard
- **Exit criteria:** the Verification Standard can describe, without
  hand-waving, how it would check a claim produced under the Evidence
  Standard, for a Skill defined under Phase 1.

## Phase 3 — Measurement

Make agent, Skill, and Workflow quality a reproducible number instead of an
opinion.

- [ ] RFC-0007: Benchmark Standard
- [ ] A minimal reference benchmark suite proving the standard is runnable,
      published as a separate repository once the standard reaches
      `Candidate` status (kept out of this repository to preserve its
      nature as a specification, not an implementation — see
      [VISION.md](./VISION.md), "What FrogAI is not").
- **Exit criteria:** a Benchmark result produced by one implementer is
  independently reproduced by another, within the tolerance the standard
  defines.

## Phase 4 — Portability

Prove the specification is implementable by tools FrogAI does not control.

- [ ] RFC-0008: Adapter Standard
- [ ] At least one reference Adapter (target tool to be selected via RFC,
      from Continue, Claude Code, Codex CLI, Cline, Roo, or Cursor, based on
      openness of extension surface at the time).
- [ ] At least one third-party-authored Adapter for a different tool, built
      from the published specification without maintainer involvement.
- **Exit criteria:** two independently built Adapters both correctly run
  the same Skill/Workflow fixture, per Phase 1's worked example.

## Phase 5 — Conformance

Give implementers a testable target instead of a prose promise.

- [ ] A conformance test suite for each Phase 1–4 specification.
- [ ] Defined conformance **Profiles** (named bundles of specification
      versions an implementation can claim, per
      [`specification/README.md`](./specification/README.md)).
- **Exit criteria:** an implementer can run the conformance suite against
  their own Adapter/tool and get a pass/fail result with no manual
  interpretation required.

## Phase 6 — v1.0 Stabilization

- [ ] Every specification produced in Phases 1–4 reaches `Stable` status
      (see the status lifecycle in
      [`specification/README.md`](./specification/README.md)).
- [ ] A documented deprecation and migration policy has been exercised at
      least once (i.e., some non-critical part of the spec has already gone
      through a real deprecation cycle before v1.0 is declared, so the
      process is proven, not theoretical).
- **Exit criteria:** GOVERNANCE.md's amendment process has been used at
  least once for something non-trivial, proving the project can evolve its
  own rules under its own process.

## Ongoing, not phase-gated

- Governance and RFC process refinement — these can and should improve
  continuously; see the amendment process in
  [GOVERNANCE.md](./GOVERNANCE.md).
- Glossary and architecture documentation upkeep in
  [`docs/`](./docs/README.md) as new specifications are accepted.

## How this roadmap changes

This document is not itself normative — it does not define behavior any
implementation must follow. It may be updated by maintainers to reflect
reality (e.g., reordering RFCs, adjusting exit criteria) without a full RFC,
but any change that removes or weakens an exit criterion must be called out
explicitly in the pull request description, per
[CONTRIBUTING.md](./CONTRIBUTING.md).
