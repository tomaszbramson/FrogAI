# Future RFC Candidates

A tracker for topics that are not yet RFCs but have surfaced as gaps worth
addressing later — either flagged as "Unresolved questions" in an existing
RFC, or identified independently while working on the foundation of the
project. This is not itself normative and does not require RFC-process
approval to edit; it is a scope-discipline tool so a good idea raised in one
RFC's Discussion does not get lost or force an unrelated scope expansion of
that RFC (see [CONTRIBUTING.md](./CONTRIBUTING.md), "Scope discipline").

Adding an entry here does not commit the project to writing that RFC, and
removing an entry (because it was written up, folded into an existing RFC,
or rejected as out of scope) does not require special process — a normal
pull request suffices.

## Candidates

| Topic | Origin | Notes |
|---|---|---|
| **Agent Identity** | Cross-cutting gap | No RFC currently defines how an *Agent* (as opposed to a Skill/Workflow/Rule Instance) identifies itself across executions — relevant to `produced_by` (RFC-0004 §1, RFC-0006 §1) attribution and to Rule `role` (RFC-0005 §2) accountability. |
| **Provenance Chains** | Cross-cutting gap | Evidence (RFC-0004) and Memory (RFC-0006) each carry single-hop provenance (`produced_by`); neither specifies how to trace a chain of derived claims back through multiple executions (e.g. a Memory Record backed by Evidence that was itself derived from an earlier Memory Record). |
| **Structured pre/postcondition expressions** | RFC-0001 Unresolved questions | Whether `preconditions`/`postconditions` should support a structured, machine-checkable expression syntax beyond free-text strings. |
| **Workflow conditional branching on output values** | RFC-0002 Unresolved questions | Branching on a step's *output value*, not just success/failure, was deliberately deferred; would need a minimal expression grammar RFC-0002 currently avoids. |
| **Workflow checkpoint/resume representation** | RFC-0002 Unresolved questions | Candidate for RFC-0006 (Memory Standard) as a durable-state concern; not yet addressed there. |
| **Rule negative scope selectors** | RFC-0003 Unresolved questions | Whether `applies_to` should support excluding specific Skills/Workflows from an otherwise-global Rule, versus relying on higher-precedence narrower Rules. |
| **Static Rule Conflict detection** | RFC-0003 Unresolved questions | Whether conflict detection must run before any action is attempted, rather than only at the moment of the conflicting action; likely a Verification (RFC-0005) concern. |
| **Content-addressable `content_ref`** | RFC-0004 Unresolved questions | Whether Evidence's `content_ref` should be required to use content-addressable storage rather than a plain location URI plus separate `integrity` field. |
| **Signable Evidence Bundle envelope** | RFC-0004 Unresolved questions | A standard, signable envelope format for an entire Evidence Bundle, for supply-chain-style attestation. |
| **Human override of automated Verification failure** | RFC-0005 Unresolved questions | Whether a human Verifier may override an automated `Fail`, and whether the override itself must produce its own Verification Record with a `rationale`. |
| **Memory concurrent-write tie-break** | RFC-0006 Unresolved questions | Whether concurrent writers producing different `value`s for the same `(scope, key)` need a defined tie-break rule. |
| **Session-scope Memory eviction policy** | RFC-0006 Unresolved questions | Whether a standard eviction/pruning policy is needed, beyond "MUST NOT be read by any other execution." |
| **Benchmark metric normalization** | RFC-0007 Unresolved questions | Whether cross-hardware/infrastructure normalization for `latency`/`cost` metrics belongs in the standard or is left to the Suite author. |
| **Canonical reference Benchmark Suite** | RFC-0007 Unresolved questions | Whether FrogAI should maintain its own reference Suite, distinct from third-party Suites using the RFC-0007 format. |
| **Adapter Manifest certification/registry** | RFC-0008 Unresolved questions | Whether a formal certification or registry process is needed for who attests that an Adapter's `mappings` are accurate; flagged there as a candidate `GOVERNANCE.md` amendment rather than an RFC. |
| **Adapter roadmap-vs-permanent gaps** | RFC-0008 Unresolved questions | Whether a `partial` Adapter should be able to distinguish "will never support this field" from "not yet supported, tracked on a roadmap." |

## Already resolved (kept for history)

- **`side_effects` `memory-write` category** — flagged in RFC-0006's
  Unresolved questions as belonging in RFC-0001; resolved directly in
  RFC-0001 §2 as part of this foundation-improvement pass.
- **Verification Record retention** — flagged in RFC-0005's Unresolved
  questions; resolved in RFC-0006 §5, which assigns retention to the Memory
  model.
