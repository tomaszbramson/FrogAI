# FrogAI to Continue Mapping

The Continue adapter does not define engineering behavior.

Its job is only to expose the frozen FrogAI runtime to Continue by turning the runtime files into numbered `.md` rules inside the target project's `.continue/rules/` directory.

## Installed rule order

1. `frogai/core/behavior.md` → `01-frogai-behavior.md`
2. `frogai/core/context-awareness.md` → `02-frogai-context-awareness.md`
3. `frogai/core/repository-awareness.md` → `03-frogai-repository-awareness.md`
4. `frogai/core/evidence.md` → `04-frogai-evidence.md`
5. `frogai/core/reasoning.md` → `05-frogai-reasoning.md`
6. `frogai/core/communication.md` → `06-frogai-communication.md`
7. `frogai/core/code-quality.md` → `07-frogai-code-quality.md`
8. `frogai/core/task-management.md` → `08-frogai-task-management.md`
9. `frogai/core/safety.md` → `09-frogai-safety.md`
10. `frogai/capabilities/project-analysis.md` → `10-frogai-project-analysis.md`

## Continue-specific behavior

- Each installed rule gets Continue YAML frontmatter.
- Rules are written in lexicographical order so Core loads before the Project Analysis capability.
- Continue concatenates the installed rules into the system message for Agent requests.

## Why this works

- Core stays reusable.
- Project Analysis stays capability-specific.
- The adapter stays responsible only for installation and rule mapping.