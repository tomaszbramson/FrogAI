# The FrogAI Manifesto

We are building a specification, not a product. These are the beliefs that
constrain every decision made in this repository. Where a design choice
conflicts with one of these statements, the statement wins.

## 1. Agents are software components, not magic

An AI coding agent is a component in a software system: it has inputs,
outputs, side effects, and failure modes. It must be specified, versioned,
tested, and held to a contract like any other component. "The model is
smart enough to figure it out" is not an architecture.

## 2. A capability that cannot be named cannot be governed

If a team cannot point to the specific Skill, Rule, or Workflow that caused
an agent to behave a certain way, they cannot audit it, fix it, or improve
it. Every unit of agent behavior must be nameable, versioned, and traceable
to a single, unambiguous definition.

## 3. Portability is a right, not a feature

Work invested in describing how an agent should behave must not be held
hostage by a single vendor's file format. A Skill authored for one tool
must be able to run on another through a well-defined Adapter, without
rewriting its intent. Lock-in is a failure of the specification, not an
acceptable trade-off.

## 4. Trust requires Evidence and Verification, not vibes

"It worked when I tried it" is not a standard. An agent's claim that a task
succeeded must be backed by Evidence that can be independently checked, and
that Evidence must pass Verification before the claim is accepted. This
applies equally to a human reviewing a PR and to an automated gate.

## 5. Memory is a liability until it is scoped

An agent that remembers things it should not, forgets things it should
retain, or cannot explain where a piece of context came from is a source of
silent failure. Memory is powerful and dangerous in equal measure, and must
be specified as precisely as any other primitive — never bolted on as an
implementation detail of a single tool.

## 6. If it cannot be measured, it cannot be improved

Claims about agent quality — "more reliable," "fewer errors," "better at
refactors" — are meaningless without a reproducible Benchmark. FrogAI treats
benchmarking as a first-class specification concern, not an afterthought
left to individual vendors' marketing.

## 7. Maintainability over speed

We optimize for a specification that is still correct, understandable, and
extendable in ten years, not for the fastest path to a v0.1 demo. Every
shortcut taken today is a migration someone else has to do later. We would
rather ship a smaller, well-reasoned surface than a large, brittle one.

## 8. Explicitness over cleverness

A specification that requires insider knowledge to interpret correctly has
already failed. If a rule needs a paragraph of tribal knowledge to apply
correctly, the rule is wrong, not the reader. Every normative statement
must be resolvable without asking the author what they meant.

## 9. Standards over examples

Examples illustrate; they do not define. FrogAI never lets an example become
the de facto specification by omission. If behavior matters, it is written
down as a normative rule in a specification document — not inferred from a
sample file that happened to be the first one anyone wrote.

## 10. One concept, one definition

Every term in this project is defined exactly once, in exactly one place
(the [Glossary](./docs/GLOSSARY.md) for informal use, the relevant RFC/spec
for normative use). No document is allowed to silently redefine a term that
already has an owner. Ambiguity introduced by drift is treated as a defect.

## 11. Backward compatibility is a design constraint, not an afterthought

Specifications are versioned from day one. A breaking change is a new major
version with a documented migration path, decided through the RFC process —
never a silent edit to an existing document. We assume, from the first RFC
onward, that someone is depending on what we publish.

## 12. Governance is written down before it is needed

Disputes, scope disagreements, and maintainer succession are designed for in
[GOVERNANCE.md](./GOVERNANCE.md) before they happen, not improvised in the
moment they occur. A specification project that cannot explain how it makes
decisions cannot be trusted to make good ones.

---

These principles are deliberately restrictive. A project that will be relied
upon by tools it does not control cannot afford to be casual about what it
promises.
