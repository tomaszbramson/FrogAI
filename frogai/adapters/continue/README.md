# FrogAI Continue Adapter

Use this adapter to install the FrogAI MVP into any real project that you want to analyze inside Continue.

## Prerequisites

1. Continue installed in your editor.
2. FrogAI cloned locally.
3. One local model available in Ollama.

## 1. Configure Continue

Create or update `~/.continue/config.yaml`:

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

Replace `model` with the exact value shown by `ollama list`, such as your local Devstral or Qwen 3.5 model.

## 2. Install FrogAI into a target project

From the FrogAI repository root, run:

```sh
./frogai/adapters/continue/install.sh /path/to/real/project
```

## 3. Use it in Continue

1. Open the target project in Continue Agent mode.
2. Select your local Agent model.
3. Ask: `Analyze this project.`

## 4. Verify the install

- The target project should contain `.continue/rules/`.
- That directory should contain FrogAI rule files prefixed with numbers.
- Continue should show those rules in its rules toolbar.

If rules do not appear, confirm the files were installed into `.continue/rules/` and reopen the target workspace.