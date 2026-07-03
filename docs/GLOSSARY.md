# Glossary

The canonical definition of every term used across FrogAI's RFCs,
specifications, and documentation. Per
[MANIFESTO.md](../MANIFESTO.md) principle 10, a term is defined exactly
once — here, informally, for general understanding — with the normative
definition owned by the RFC/specification noted in the "Defined by" column.
Until an RFC is accepted, its entry describes the term's *intended* meaning
as agreed at proposal time; the informal definition below is expected to
converge with, not diverge from, that RFC once accepted.

Terms are listed alphabetically. If you need to introduce a new term, do it
in the RFC that needs it first — see [`docs/README.md`](./README.md).

| Term | Definition | Defined by |
|---|---|---|
| **Adapter** | A translation layer that maps FrogAI-conformant Skills, Rules, Workflows, and Evidence onto a specific agent tool's native configuration format and runtime behavior, so that a specification-level object can execute unmodified across tools. | RFC-0008 (pending) |
| **Agent** | Any AI-driven software system that reads instructions (Skills, Rules, Workflows) and takes autonomous or semi-autonomous action on a codebase — e.g. Cursor, Claude Code, Codex CLI, Cline, Roo, Continue, or a future entrant. FrogAI does not assume any particular model, context window, or execution loop implementation. | — (used across all RFCs; not itself normatively defined by a single RFC, since FrogAI does not specify agents themselves, only the contracts they consume) |
| **Benchmark** | A reproducible measurement procedure and scoring method for evaluating the performance of a Skill, Workflow, or Agent against a defined set of tasks, such that two independent runs by different implementers converge within a stated tolerance. | RFC-0007 (pending) |
| **Conformance** | The property of an implementation (Agent, Adapter, or tool) correctly satisfying every `MUST`/`MUST NOT`/`REQUIRED` statement in a given specification document or Profile. | `specification/README.md` |
| **Evidence** | A verifiable artifact (e.g. a diff, a test run's output, a citation, a log excerpt) that substantiates a specific claim an Agent makes about the outcome of an action, sufficient for independent verification without re-running the original session. | RFC-0004 (pending) |
| **FCP (Final Comment Period)** | The final, minimum-10-calendar-day window before an RFC decision, during which a new substantive objection sends the RFC back to Discussion. | `rfcs/README.md` |
| **Maintainer** | A project role with merge rights and RFC-acceptance voting rights, accountable for the specification's overall technical quality and consistency. | `GOVERNANCE.md` |
| **Memory** | Durable, explicitly scoped state that an Agent may read or write across separate invocations or sessions, together with the provenance metadata needed to know where a remembered fact came from and when it expires. | RFC-0006 (pending) |
| **Profile** | A named, versioned bundle of specific version numbers of Level 1–3 specification documents that an implementation can claim conformance to as a single, checkable unit. | `specification/README.md` |
| **Project Lead** | A temporary, single-person governance role held during the project's early phase, providing tie-breaking authority until a multi-maintainer group is established. | `GOVERNANCE.md` |
| **RFC (Request for Comments)** | A written proposal for a normative change to FrogAI, which must pass through Draft, Discussion, and Final Comment Period before being Accepted or Rejected. | `rfcs/README.md` |
| **Rule** | A constraint on Agent behavior that holds independently of any single task — something that must always, or never, be true while the Agent operates, regardless of which Skill or Workflow is currently executing. | RFC-0003 (pending) |
| **Skill** | An atomic, contract-bound unit of Agent capability: a named, versioned definition of one thing an Agent knows how to do, including its required inputs, expected outputs, and preconditions/postconditions. | RFC-0001 (pending) |
| **Specification** | A normative document under [`specification/`](../specification/README.md), produced by an Accepted RFC, that defines binding behavior for conformant implementations. | `specification/README.md` |
| **Verification** | The process and set of gates by which the Evidence attached to an Agent's claim is checked for validity before that claim is accepted — by a human reviewer, an automated check, or both. | RFC-0005 (pending) |
| **Workflow** | An orchestrated sequence or graph of Skills (and optionally nested Workflows), governed by applicable Rules, executed to accomplish a goal larger than any single Skill covers. | RFC-0002 (pending) |
