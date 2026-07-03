# FrogAI

FrogAI is a modular runtime that makes Continue behave more like an experienced software engineer during project analysis.

## Quick start

1. Install the Continue extension.
2. Configure one local Agent model in `~/.continue/config.yaml`.
3. Install the FrogAI Continue adapter into the real project you want to inspect.
4. Open that project in Continue Agent mode.
5. Ask: `Analyze this project.`

## Minimal Continue config

```yaml
name: FrogAI Local
version: 0.0.1
schema: v1

models:
  - name: Local Agent
    provider: ollama
    model: <MODEL_ID_FROM_OLLAMA_LIST>
    roles:
      - chat
      - edit
      - apply
    capabilities:
      - tool_use
```

Replace `model` with the exact identifier from `ollama list`, for example your local Devstral or Qwen 3.5 model.

## Install FrogAI into a target project

```sh
./frogai/adapters/continue/install.sh /path/to/real/project
```

The installer writes FrogAI rules into the target project's `.continue/rules/` directory.

## Detailed setup

See `frogai/adapters/continue/README.md` for the full Continue setup and verification flow.

## Repository layout

- `frogai/core/` reusable engineering behavior
- `frogai/capabilities/project-analysis.md` the only MVP capability
- `frogai/adapters/continue/` installer and Continue-specific mapping
