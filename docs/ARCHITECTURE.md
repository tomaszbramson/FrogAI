# Architecture

This document explains how FrogAI's core objects relate to each other as a
system. It is informative, not normative — see
[`specification/README.md`](../specification/README.md) for the
authoritative hierarchy and status rules. Term definitions live in the
[Glossary](./GLOSSARY.md); this document does not redefine them.

## The shape of the system

```
                        ┌─────────────────────────────┐
                        │            Rule              │  always-on constraints
                        └──────────────┬───────────────┘
                                       governs
                                        ▼
   ┌────────────┐     composes    ┌───────────────┐
   │   Skill    │◄────────────────┤   Workflow    │
   └─────┬──────┘                 └───────┬───────┘
         │ executed by an Agent produces  │
         ▼                                ▼
   ┌─────────────────────────────────────────────┐
   │                   Evidence                    │  claims + artifacts
   └───────────────────────┬───────────────────────┘
                          checked by
                            ▼
   ┌─────────────────────────────────────────────┐
   │                 Verification                  │  accept / reject claim
   └─────────────────────────────────────────────┘

   ┌────────────┐        read/write across        ┌─────────────┐
   │   Agent    │◄─────────────────────────────────┤   Memory     │
   └─────┬──────┘                                  └─────────────┘
         │ measured by
         ▼
   ┌─────────────────────────────────────────────┐
   │                  Benchmark                     │  reproducible scoring
   └─────────────────────────────────────────────┘

   ┌─────────────────────────────────────────────┐
   │                   Adapter                      │  binds all of the above
   │        to a specific tool's runtime            │  (Cursor, Claude Code, …)
   └─────────────────────────────────────────────┘
```

## Reading the diagram

- **Rule** sits above everything because it is not invoked — it constrains.
  A Rule is not "run" the way a Skill is; it is evaluated continuously
  against whatever the Agent is doing under any Workflow or Skill.
- **Workflow** composes **Skills** (and, recursively, other Workflows) into
  a larger unit of work. A Workflow does not introduce new primitive
  capability — everything it does is expressible as some composition of
  Skills, which is what keeps Skill the smallest normatively-defined unit.
- **Evidence** is the output contract of executing a Skill or Workflow: any
  claim of success or failure the Agent makes must be attached to Evidence,
  not asserted on its own.
- **Verification** consumes Evidence and produces an accept/reject
  decision. Verification never has to inspect the Agent's live session —
  by design, Evidence must be sufficient on its own (see
  [MANIFESTO.md](../MANIFESTO.md) principle 4).
- **Memory** is orthogonal to a single Skill/Workflow execution — it is the
  channel through which state survives *between* executions. It is drawn
  separately because, unlike Evidence, it is not produced by any single
  Skill call; it is a persistent store the Agent consults and updates.
- **Benchmark** measures the Agent (and, by extension, the Skills/Workflows
  it was given) against reproducible tasks — it operates one level above a
  single execution, similar to Memory, but backward-looking/aggregate
  rather than a live read/write channel.
- **Adapter** is drawn wrapping the whole system because it is not another
  primitive alongside the others — it is the binding of every primitive
  above onto one specific tool's actual runtime and file formats. A tool
  fully "speaks FrogAI" when its Adapter correctly implements this binding
  for every primitive it claims to support (see Profiles in
  `specification/README.md`).

## Why exactly these eight primitives

Each addition to this set is a permanent specification and compatibility
burden (see [MANIFESTO.md](../MANIFESTO.md) principle 7). The current set
was chosen because each primitive answers a question none of the others
can answer:

- Skill/Rule/Workflow answer **"what is the Agent instructed to do, and
  under what constraints?"**
- Evidence/Verification answer **"how do we know it actually happened, and
  correctly?"**
- Memory answers **"what carries over, and how do we know where it came
  from?"**
- Benchmark answers **"is this Agent/Skill/Workflow actually getting
  better?"**
- Adapter answers **"how does any of this run on a tool FrogAI does not
  control?"**

A proposal to add a ninth primitive should be able to state, precisely,
which of these questions is currently unanswerable — see the RFC template's
"Rationale and alternatives" section in
[`rfcs/0000-template.md`](../rfcs/0000-template.md).

## Layering and dependency direction

This mirrors the Level 0–4 hierarchy in
[`specification/README.md`](../specification/README.md): Core objects
(Skill, Rule, Workflow) never depend on Standards (Evidence, Verification,
Memory, Benchmark), which never depend on Adapters, which never depend on
Profiles. Dependencies only point "downward" in the diagram above — this is
what allows each specification document to be read, and implemented, on
its own.
