#!/usr/bin/env bash
# PreToolUse hook: Warn if [DEBUG] log statements are in staged files during git commit
# This hook reads the tool input from stdin and checks if it's a git commit command.
# If so, it scans staged .cs files for [DEBUG] markers and warns.

set -euo pipefail

# Read the tool input from stdin
INPUT=$(cat)

# Extract the command from the input JSON
COMMAND=$(echo "$INPUT" | python3 -c "import sys,json; d=json.load(sys.stdin); print(d.get('tool_input',{}).get('command',''))" 2>/dev/null || echo "")

# Only check on git commit commands
if ! echo "$COMMAND" | grep -q "git commit"; then
  echo '{"decision":"approve"}'
  exit 0
fi

# Check staged .cs files for [DEBUG] log markers
DEBUG_FILES=$(git diff --cached --name-only -- '*.cs' 2>/dev/null | while read -r file; do
  if [ -f "$file" ] && grep -l '\[DEBUG\]' "$file" 2>/dev/null; then
    echo "$file"
  fi
done)

if [ -n "$DEBUG_FILES" ]; then
  # Build the warning message
  FILE_LIST=$(echo "$DEBUG_FILES" | tr '\n' ', ' | sed 's/,$//')
  cat <<EOF
{
  "decision": "approve",
  "message": "Warning: [DEBUG] log statements found in staged files: ${FILE_LIST}. Remove diagnostic logs before committing the fix (see unity-systematic-debugging skill, Phase 1)."
}
EOF
else
  echo '{"decision":"approve"}'
fi

exit 0
