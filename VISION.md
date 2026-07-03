# Vision

## The destination

A developer writes a Skill once — say, "run our project's flaky-test
quarantine procedure" — as a FrogAI-conformant document. That Skill runs
unmodified on Claude Code, Cursor, Codex CLI, Cline, Roo, and Continue, via
an Adapter maintained either by that tool's own community or by FrogAI's
reference implementations. The team's Rules ("never commit directly to
`main`," "always add a changelog entry") apply consistently no matter which
agent an individual developer prefers. When an agent claims a migration is
safe, that claim comes with Evidence a reviewer can check in seconds, and a
Verification gate that would have caught it if it were wrong. When the team
asks "is our agent setup actually working better than six months ago?" they
run a Benchmark and get a number, not an opinion.

None of this requires the team to trust one vendor, adopt one IDE, or bet on
one model provider. That is the world FrogAI is built to enable.

## Why now

Coding agents have crossed from novelty to daily-use infrastructure faster
than the tooling ecosystem has produced shared standards for them. This is
the same phase HTTP APIs were in before OpenAPI, editor tooling was in
before the Language Server Protocol, and model-context integration was in
before MCP. In each case, an early, ownable, well-specified standard
absorbed the fragmentation and became the substrate the rest of the industry
built on. The window for that to happen for agent Skills/Rules/Workflows is
open now, not indefinitely — every month without a shared spec is another
month of vendor-specific formats hardening into de facto standards nobody
designed on purpose.

## What FrogAI is

- A **specification project**, whose primary artifact is a versioned set of
  documents under [`specification/`](./specification/), each produced
  through an accepted RFC.
- A **neutral standard**, owned by no single agent vendor or model provider,
  licensed to be implemented by anyone without royalty.
- A **reference, not a runtime** — FrogAI defines the contracts; it does not
  require teams to run FrogAI's own software to benefit from them. Reference
  Adapters and validators exist to prove the specification is implementable
  and to lower the adoption cost, not to become the only implementation.

## What FrogAI is not

- **Not a prompt library.** A collection of "good prompts" is not a
  specification; it has no contract, no versioning, and no way to verify
  conformance. FrogAI defines what a Skill *is*, not a catalog of specific
  skills.
- **Not an IDE, CLI, or agent runtime.** FrogAI does not compete with
  Cursor, Claude Code, Codex CLI, Cline, Roo, or Continue. It defines the
  contract those tools can choose to speak.
- **Not tied to any single model provider.** Nothing in the specification
  may assume a specific model's capabilities, context window, or API shape.
  If a proposal only works for one model family, it is not ready to be a
  FrogAI standard.
- **Not a certification racket.** Conformance profiles (see the Roadmap)
  exist to give implementers a clear, testable target — not to create a
  paid gate in front of adoption.

## How we will know we succeeded

These are the outcomes the project is optimizing for, in increasing order of
ambition:

1. **A single team** can write one Skill/Rule/Workflow definition and run it
   against two or more different agent tools without modification, via
   Adapters.
2. **A third-party tool builder**, with no communication with FrogAI's
   maintainers, implements an Adapter for their own agent from the published
   specification alone — proving the spec is precise enough to implement
   independently.
3. **An independent auditor** can take an agent's Evidence trail for a
   completed task and, using only the Verification specification, determine
   whether the task's claims hold up — without access to the original agent
   session.
4. **A published Benchmark result** for a Skill or Workflow is reproducible
   by a different team, on different infrastructure, within an agreed
   tolerance.
5. **At least one major agent tool** (from the Continue / Claude Code /
   Codex CLI / Cline / Roo / Cursor set, or a future entrant) ships native
   or first-class support for a FrogAI specification version, driven by
   external demand rather than by FrogAI's own advocacy.
6. **Multiple, independently maintained Adapters** exist for the same agent
   tool, and they interoperate — evidence that the specification, not any
   single implementation, is the source of truth.

## Non-goals, permanently

- Picking a "best" model or agent tool. FrogAI is neutral by construction
  and stays neutral by governance (see [GOVERNANCE.md](./GOVERNANCE.md)).
- Optimizing for the fastest v1.0. See Principle 7 in the
  [Manifesto](./MANIFESTO.md): maintainability over speed is permanent, not
  a phase-0-only constraint.
- Growing the number of core primitives without discipline. Every new
  primitive is a permanent maintenance and compatibility burden; the bar for
  adding one beyond Skill, Rule, Workflow, Evidence, Verification, Memory,
  Benchmark, and Adapter is intentionally high.

See [ROADMAP.md](./ROADMAP.md) for the phased path from where the project is
today to this vision.
