---
rfc: 8
title: Adapter Standard
status: Draft
authors: [tomaszbramson]
created: 2026-07-03
updated: 2026-07-03
supersedes: null
superseded-by: null
---

## Summary

Defines **Adapter**: a versioned Manifest declaring how a specific agent
tool (Cursor, Claude Code, Codex CLI, Cline, Roo, Continue, or any future
entrant) maps FrogAI-conformant Skills (RFC-0001), Workflows (RFC-0002),
Rules (RFC-0003), Evidence (RFC-0004), Verification (RFC-0005), Memory
(RFC-0006), and Benchmark (RFC-0007) onto its own native configuration
format and runtime behavior. An Adapter's central obligation is honesty
about fidelity: where a tool cannot fully represent a FrogAI primitive, the
Manifest MUST say so explicitly, and MUST refuse to silently execute with
weaker guarantees than declared.

## Motivation

Every other FrogAI RFC defines a portable, tool-agnostic contract. None of
that portability exists in practice until something maps a Skill Instance
onto Cursor's `.mdc` format, a Rule onto Claude Code's project
instructions, or a Workflow onto whatever orchestration a given tool
supports natively — and does so without silently dropping a `blocking`
Rule or an exhaustive `side_effects` declaration along the way. Every RFC
so far (0001 §"Adoption and migration" through 0007) has deferred its
per-tool mapping to "RFC-0008 (Adapter Standard)." This RFC is where those
deferrals are finally answered.

## Terminology

New terms, to be added to [`docs/GLOSSARY.md`](../docs/GLOSSARY.md) when
this RFC is accepted (the existing `Adapter` entry there is superseded by
the normative definition in this RFC's Summary):

- **Adapter Manifest** — the versioned document defined by this RFC.
- **Capability** — an Adapter's declared support level (`full`, `partial`,
  `none`) for one FrogAI primitive type.
- **Fidelity Gap** — a specific field of a primitive an Adapter cannot
  faithfully represent in the target tool's native format or runtime.

## Detailed design

### 1. Adapter Manifest format

An Adapter Manifest MUST be a document with a metadata block (front
matter, YAML) and an OPTIONAL free-text body describing tool-specific
setup, mirroring the shape used by every other primitive in this project.

### 2. Required metadata fields

| Field | Type | Description |
|---|---|---|
| `id` | string | Globally unique; stable across versions. |
| `version` | string (SemVer) | Version of this Manifest. |
| `name` | string | Short human-readable name (e.g. "FrogAI Adapter for Claude Code"). |
| `status` | enum | `Draft`, `Active`, `Deprecated`, `Retired` — the lifecycle reused from every prior primitive RFC. |
| `target_tool` | string | Identifier of the tool this Adapter targets (e.g. `cursor`, `claude-code`, `codex-cli`, `cline`, `roo`, `continue`). |
| `profile` | string | A Profile reference (`specification/README.md`'s Level 4) naming the exact bundle of Level 1–3 specification versions this Adapter implements — reused rather than inventing a second per-Adapter versioning scheme. |
| `capabilities` | map | One entry per primitive type (`skill`, `workflow`, `rule`, `evidence`, `verification`, `memory`, `benchmark`) → `full`, `partial`, or `none`. Primitives absent from this map are treated as `none`. |
| `mappings` | list of Mapping objects | See §3. REQUIRED for every primitive whose `capabilities` entry is `full` or `partial`. |

### 3. Mapping object

Each entry in `mappings` MUST include:

| Field | Type | Description |
|---|---|---|
| `primitive` | enum | One of the seven primitive types listed in §2. |
| `target_construct` | string | A description or path identifying the native format/mechanism this primitive maps onto (e.g. "`.cursor/rules/*.mdc` frontmatter"). |
| `unsupported_fields` | list of string | REQUIRED (MAY be empty) if `capabilities[primitive] = partial`; MUST be absent or empty if `full`; MUST NOT be present if `none`. Names every required or optional field of that primitive's specification (RFC-0001 §2–3, RFC-0002 §2–3, RFC-0003 §2, etc.) this Adapter cannot faithfully represent. |
| `direction` | enum | `push-only` (FrogAI Instance → native format only) or `bidirectional` (native edits are also translated back). Default `push-only`. |

### 4. Fail-closed loading

If a FrogAI Instance uses a field listed in that primitive's
`unsupported_fields`, a conformant Adapter MUST refuse to load or execute
that Instance and MUST surface exactly which field triggered the refusal
— it MUST NOT silently execute the Instance while ignoring or
approximating the unsupported field. This is the same
refuse-rather-than-guess posture RFC-0001 §2 requires for a Skill missing
a required field, applied here to the tool-boundary case instead of the
authoring-time case.

### 5. Rule enforcement fidelity

An Adapter with `capabilities.rule = partial` or `none` MUST refuse to
load any `blocking` Rule (RFC-0003 §5) whose `statement` it cannot
actually enforce in the target tool's runtime — it MUST NOT present an
unenforceable `blocking` Rule as if it were active. An `advisory` Rule MAY
be loaded with reduced fidelity (e.g. surfaced as a comment) since its
violation was never going to block execution. This directly extends
RFC-0003's own security posture (fail-closed on Rule conflicts) to the
Adapter boundary, where a silently-dropped `blocking` Rule would be worse
than a Rule Conflict: not ambiguous, just silently absent.

### 6. Benchmark reference (optional)

An Adapter Manifest MAY declare a `fidelity_benchmark` field referencing a
Benchmark Suite (RFC-0007, `target: agent`) used to demonstrate that this
Adapter's mappings preserve the behavior FrogAI specifies. This is
advisory, not required — a Manifest without one is still conformant if
§2–§5 are satisfied.

## Rationale and alternatives

- **Explicit `unsupported_fields`, not best-effort silent mapping.**
  Rejected letting an Adapter approximate unsupported fields quietly:
  every prior RFC in this project (0001 §2, 0003 §2, 0004 §1) already
  requires refusing rather than guessing when a required contract element
  is missing or unrepresentable — an Adapter is the last place that
  discipline could leak, so it gets the same rule.
- **Per-primitive `capabilities`, not one Adapter-wide flag.** A real tool
  is rarely uniformly good or bad across all seven primitives (e.g. a
  tool with rich rule-scoping but no workflow orchestration at all);
  collapsing this into one flag would force an honest Adapter to mark
  itself `partial` overall even where it is fully faithful for most
  primitives.
- **Reusing `specification/README.md`'s Profile concept** for `profile`,
  rather than a bespoke per-Adapter version list — an Adapter's
  conformance target is exactly what a Profile already exists to name.
- **`push-only` as the default direction.** Most native tool formats
  cannot round-trip losslessly back into a full FrogAI Instance (they
  often lack fields like `postconditions` or `side_effects` entirely);
  requiring bidirectionality by default would make most real Adapters
  non-conformant. `bidirectional` is opt-in and requires its own
  Mapping-level declaration.

## Backward compatibility

New specification; no prior `Stable` document to break. Once
`specification/adapters/adapter.md` reaches `Stable`, changing the
required fields in §2–§3 or weakening the fail-closed requirements in §4–§5
is a breaking change requiring a new RFC and a MAJOR version bump.

## Security and trust considerations

The Adapter is the exact boundary where FrogAI's safety guarantees
(exhaustive `side_effects`, `blocking` Rule enforcement) either survive
translation into a real tool's runtime or don't. §4 and §5's fail-closed
requirements exist because a mistranslated safety-relevant field is worse
than a missing one — a Rule that silently stops being enforced while still
appearing to exist is a false sense of safety, which is strictly worse
than no Rule at all.

## Adoption and migration

This RFC standardizes the Manifest format only; it does not itself ship
Adapters for Cursor, Claude Code, Codex CLI, Cline, Roo, or Continue —
writing those is implementation work for a future phase (see
[`ROADMAP.md`](../ROADMAP.md)), each as its own Manifest once this RFC is
Accepted. Every prior RFC's "Adoption and migration" section already
identifies the specific native construct each tool uses today that a
Mapping (§3) would target.

## Unresolved questions

- Should there be a formal certification or registry process for Adapter
  Manifests (who attests that a Manifest's `mappings` are accurate), or is
  self-declaration with public review sufficient? Left open — candidate
  for a future `GOVERNANCE.md` amendment rather than this RFC.
- Should a `partial` Adapter be able to distinguish "will never support
  this field" from "doesn't support it yet, tracked on a roadmap"? Left
  open pending real Adapter authoring experience.

## Decision record

- **FCP proposed by:** —
- **FCP start/end:** —
- **Outcome:** —
- **Rationale:** —
