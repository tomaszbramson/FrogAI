#!/bin/sh
set -eu

usage() {
  echo "Usage: $0 /path/to/project [--force]" >&2
  exit 1
}

PROJECT_PATH=${1:-}
FORCE=${2:-}

[ -n "$PROJECT_PATH" ] || usage
[ -d "$PROJECT_PATH" ] || {
  echo "Target project directory not found: $PROJECT_PATH" >&2
  exit 1
}
[ -z "$FORCE" ] || [ "$FORCE" = "--force" ] || usage

SCRIPT_DIR=$(CDPATH= cd -- "$(dirname "$0")" && pwd)
SOURCE_ROOT=$(CDPATH= cd -- "$SCRIPT_DIR/../../.." && pwd)
TARGET_ROOT=$(CDPATH= cd -- "$PROJECT_PATH" && pwd)
TARGET_DIR="$TARGET_ROOT/.continue/rules"
LEGACY_RULE="$TARGET_DIR/01-frogai-project-analysis.md"

require_file() {
  [ -f "$1" ] || {
    echo "Missing source file: $1" >&2
    exit 1
  }
}

check_conflict() {
  if [ -e "$1" ] && [ "$FORCE" != "--force" ]; then
    echo "Refusing to overwrite existing FrogAI rule: $1" >&2
    echo "Re-run with --force to replace existing FrogAI files." >&2
    exit 1
  fi
}

write_rule() {
  SOURCE_FILE=$1
  TARGET_FILE=$2
  RULE_NAME=$3
  RULE_DESCRIPTION=$4

  cat > "$TARGET_FILE" <<EOF
---
name: $RULE_NAME
alwaysApply: true
description: $RULE_DESCRIPTION
---

EOF
  cat "$SOURCE_FILE" >> "$TARGET_FILE"
}

CORE_DIR="$SOURCE_ROOT/frogai/core"
CAPABILITY_DIR="$SOURCE_ROOT/frogai/capabilities"

BEHAVIOR="$CORE_DIR/behavior.md"
CONTEXT_AWARENESS="$CORE_DIR/context-awareness.md"
REPOSITORY_AWARENESS="$CORE_DIR/repository-awareness.md"
EVIDENCE="$CORE_DIR/evidence.md"
REASONING="$CORE_DIR/reasoning.md"
COMMUNICATION="$CORE_DIR/communication.md"
CODE_QUALITY="$CORE_DIR/code-quality.md"
TASK_MANAGEMENT="$CORE_DIR/task-management.md"
SAFETY="$CORE_DIR/safety.md"
PROJECT_ANALYSIS="$CAPABILITY_DIR/project-analysis.md"

for SOURCE_FILE in \
  "$BEHAVIOR" \
  "$CONTEXT_AWARENESS" \
  "$REPOSITORY_AWARENESS" \
  "$EVIDENCE" \
  "$REASONING" \
  "$COMMUNICATION" \
  "$CODE_QUALITY" \
  "$TASK_MANAGEMENT" \
  "$SAFETY" \
  "$PROJECT_ANALYSIS"
do
  require_file "$SOURCE_FILE"
done

mkdir -p "$TARGET_DIR"

check_conflict "$LEGACY_RULE"
check_conflict "$TARGET_DIR/01-frogai-behavior.md"
check_conflict "$TARGET_DIR/02-frogai-context-awareness.md"
check_conflict "$TARGET_DIR/03-frogai-repository-awareness.md"
check_conflict "$TARGET_DIR/04-frogai-evidence.md"
check_conflict "$TARGET_DIR/05-frogai-reasoning.md"
check_conflict "$TARGET_DIR/06-frogai-communication.md"
check_conflict "$TARGET_DIR/07-frogai-code-quality.md"
check_conflict "$TARGET_DIR/08-frogai-task-management.md"
check_conflict "$TARGET_DIR/09-frogai-safety.md"
check_conflict "$TARGET_DIR/10-frogai-project-analysis.md"

if [ "$FORCE" = "--force" ] && [ -e "$LEGACY_RULE" ]; then
  rm -f "$LEGACY_RULE"
fi

write_rule "$BEHAVIOR" "$TARGET_DIR/01-frogai-behavior.md" "FrogAI Behavior" "FrogAI core engineering mindset and execution defaults."
write_rule "$CONTEXT_AWARENESS" "$TARGET_DIR/02-frogai-context-awareness.md" "FrogAI Context Awareness" "FrogAI core guidance for gathering only the context required."
write_rule "$REPOSITORY_AWARENESS" "$TARGET_DIR/03-frogai-repository-awareness.md" "FrogAI Repository Awareness" "FrogAI core repository discovery behavior."
write_rule "$EVIDENCE" "$TARGET_DIR/04-frogai-evidence.md" "FrogAI Evidence" "FrogAI core evidence and uncertainty discipline."
write_rule "$REASONING" "$TARGET_DIR/05-frogai-reasoning.md" "FrogAI Reasoning" "FrogAI core engineering workflow from understanding through validation."
write_rule "$COMMUNICATION" "$TARGET_DIR/06-frogai-communication.md" "FrogAI Communication" "FrogAI core response structure and communication style."
write_rule "$CODE_QUALITY" "$TARGET_DIR/07-frogai-code-quality.md" "FrogAI Code Quality" "FrogAI core code quality and maintainability defaults."
write_rule "$TASK_MANAGEMENT" "$TARGET_DIR/08-frogai-task-management.md" "FrogAI Task Management" "FrogAI core guidance for visible multi-step execution."
write_rule "$SAFETY" "$TARGET_DIR/09-frogai-safety.md" "FrogAI Safety" "FrogAI core safety rules for user work and repository changes."
write_rule "$PROJECT_ANALYSIS" "$TARGET_DIR/10-frogai-project-analysis.md" "FrogAI Project Analysis" "FrogAI capability for repository discovery and project analysis."

echo "Installed FrogAI Continue adapter to: $TARGET_DIR"
echo ""
echo "Next steps:"
echo "1. Open the target project in Continue Agent mode."
echo "2. Select your local Agent model."
echo "3. Ask: Analyze this project."