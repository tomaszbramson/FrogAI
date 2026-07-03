#!/bin/sh
set -eu

usage() {
  echo "Usage: $0 /path/to/project [--force]" >&2
  exit 1
}

PROJECT_PATH=${1:-}
FORCE=${2:-}

[ -n "$PROJECT_PATH" ] || usage
[ -z "$FORCE" ] || [ "$FORCE" = "--force" ] || usage

SCRIPT_DIR=$(CDPATH= cd -- "$(dirname "$0")" && pwd)
SOURCE_RULE="$SCRIPT_DIR/continue/rules/01-frogai-project-analysis.md"
TARGET_ROOT=$(CDPATH= cd -- "$PROJECT_PATH" && pwd)
TARGET_DIR="$TARGET_ROOT/.continue/rules"
TARGET_RULE="$TARGET_DIR/01-frogai-project-analysis.md"

[ -f "$SOURCE_RULE" ] || {
  echo "Missing source rule: $SOURCE_RULE" >&2
  exit 1
}

mkdir -p "$TARGET_DIR"

if [ -e "$TARGET_RULE" ] && [ "$FORCE" != "--force" ]; then
  echo "Refusing to overwrite existing rule: $TARGET_RULE" >&2
  echo "Re-run with --force to replace it." >&2
  exit 1
fi

cp "$SOURCE_RULE" "$TARGET_RULE"

echo "Installed FrogAI Project Analysis to: $TARGET_RULE"
echo ""
echo "Next steps:"
echo "1. Open the target project in Continue Agent mode."
echo "2. Choose any Continue-supported model for Agent mode."
echo "3. Ask: Analyze this project."
