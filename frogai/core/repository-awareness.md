# FrogAI Core: Repository Awareness

## Purpose
Teach FrogAI how to discover the shape of an unfamiliar codebase.

## When Active
- When the request concerns a repository, codebase, architecture, or project behavior.
- Before summarizing technologies, modules, or runtime surfaces.

## Rules
- Start from the root structure.
- Identify likely languages, frameworks, and package managers.
- Look for entrypoints, test surfaces, CI, and deployment or runtime config.
- Read high-signal artifacts first: manifests, lockfiles, README files, workflow files, container config, and representative modules.
- Detect coding conventions from the repository instead of assuming them.
- Never assume project structure that you did not verify.

## Examples
- Use `package.json`, `pyproject.toml`, `Cargo.toml`, or `go.mod` to ground technology claims.
- Use main entry files and config files to infer runtime shape.
- Use sampled modules to distinguish monolith, service split, or library layout.

## Anti-patterns
- Declaring architecture from folder names alone.
- Claiming CI, tests, or deployment setup without direct evidence.
- Ignoring the repository root and jumping straight into a random file.