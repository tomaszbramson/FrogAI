# FrogAI

**The Open Engineering Framework for AI Coding Agents.**

FrogAI defines a vendor-neutral, model-agnostic, IDE-agnostic specification for
how AI coding agents should be given **Skills**, **Rules**, and **Workflows** —
and how their behavior can be trusted through **Evidence**, **Verification**,
**Memory**, and **Benchmarks**.

It is not a product, a prompt library, or a plugin. It is a set of contracts —
in the same sense that OpenAPI is a contract for HTTP APIs, LSP is a contract
between editors and language tooling, and MCP is a contract for connecting
models to context. FrogAI is the contract for how an autonomous coding agent
is instructed, constrained, measured, and trusted, regardless of which model
or which IDE/CLI is running it.

## Why this exists

Every coding-agent tool today — Cursor, Claude Code, Codex CLI, Cline, Roo,
Continue, and others — has invented its own incompatible way of expressing
"do this task the way our team wants it done." Prompts, rule files, and
custom instructions are copy-pasted between tools, drift out of sync, and
cannot be verified, benchmarked, or audited. There is no shared vocabulary
for what a "Skill" or a "Rule" even *is*.

FrogAI exists to give the industry a shared, versioned, implementation-neutral
specification for these concepts — so that a Skill authored once can run
(via an Adapter) on any conforming agent, and so that "the agent did X" is a
claim that can be checked, not just trusted.

Read [MANIFESTO.md](./MANIFESTO.md) for the beliefs behind this project and
[VISION.md](./VISION.md) for where it is going.

## Status

**Phase 0 — Foundation.** FrogAI is currently defining its governance, RFC
process, and specification hierarchy. No Skill, Rule, or Workflow
implementation is considered stable yet — see [ROADMAP.md](./ROADMAP.md) for
the phased plan. Nothing in this repository should be treated as a stable
API until it has an accepted RFC and a corresponding document under
[`specification/`](./specification/) marked `Stable`.

## Repository layout

```
.
├── MANIFESTO.md          Beliefs and non-negotiable principles
├── VISION.md              Long-term destination and success criteria
├── ROADMAP.md             Phased plan from foundation to v1.0
├── GOVERNANCE.md          Decision-making process and roles
├── CONTRIBUTING.md        How to propose changes, RFCs, and code
├── CODE_OF_CONDUCT.md     Community standards
├── docs/                  Explanatory material: architecture, glossary
├── rfcs/                  Request for Comments — how decisions get made
└── specification/         Normative specifications produced by accepted RFCs
```

## The core objects

FrogAI defines a small set of primitives. Full definitions live in the
[Glossary](./docs/GLOSSARY.md); normative behavior is defined by their
respective RFCs and specifications once accepted.

| Object | Question it answers |
|---|---|
| **Skill** | "What is one thing an agent knows how to do, with a defined contract?" |
| **Rule** | "What must always (or never) be true about the agent's behavior?" |
| **Workflow** | "How are Skills and Rules composed to achieve a larger goal?" |
| **Evidence** | "How does the agent substantiate a claim it made?" |
| **Verification** | "How is an agent's output checked before it is trusted?" |
| **Memory** | "What does the agent retain across invocations, and how?" |
| **Benchmark** | "How is agent/Skill/Workflow performance measured, reproducibly?" |
| **Adapter** | "How does a spec-conformant Skill/Rule/Workflow run on a specific tool?" |

These are deliberately abstract at this stage. Concrete, normative
definitions are produced through the RFC process below — see the tracking
table in [`rfcs/README.md`](./rfcs/README.md).

## How specifications are made

FrogAI follows an **RFC-first** process: nothing becomes part of the
specification without going through a written proposal, open discussion, and
an explicit acceptance decision. See [`rfcs/README.md`](./rfcs/README.md)
for the full process and [`specification/README.md`](./specification/README.md)
for how accepted RFCs become versioned, normative documents.

## Design principles

FrogAI's architecture is guided by a small set of non-negotiable engineering
principles, elaborated in [MANIFESTO.md](./MANIFESTO.md):

1. **Maintainability over speed.**
2. **Explicitness over cleverness.**
3. **Standards over examples.**
4. **One concept, one definition** — never duplicated, never redefined.
5. **Backward compatibility is a design constraint, not an afterthought.**

## Who this is for

- **Tool builders** (Continue, Claude Code, Codex CLI, Cline, Roo, Cursor,
  and future agents) who want a stable contract to target instead of
  reinventing prompt/rule formats.
- **Engineering teams** who want their Skills, Rules, and Workflows to be
  portable across whichever agent tool their developers prefer.
- **Researchers and auditors** who need a way to verify and benchmark agent
  behavior against a shared, reproducible standard.

## Getting involved

FrogAI is in its foundation phase and welcomes participation in shaping the
specifications themselves. Start with:

1. [MANIFESTO.md](./MANIFESTO.md) and [VISION.md](./VISION.md) — understand
   the "why" before proposing "how."
2. [GOVERNANCE.md](./GOVERNANCE.md) — understand who decides what, and how.
3. [`rfcs/README.md`](./rfcs/README.md) — the process for proposing a change.
4. [CONTRIBUTING.md](./CONTRIBUTING.md) — practical mechanics (branches,
   commits, review).

## License

FrogAI is released under the [Apache License 2.0](./LICENSE). Specifications
are free to implement, without royalty, by any tool or vendor — this is a
deliberate choice to encourage the widest possible adoption as a neutral
industry standard.
