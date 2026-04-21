#!/usr/bin/env bash
# PreToolUse hook: Block git add/commit if Unity project has no .gitignore or is missing critical entries.
# Prevents accidentally committing Library/, Temp/, and other huge Unity directories.

set -euo pipefail

INPUT=$(cat)

COMMAND=$(echo "$INPUT" | python3 -c "import sys,json; d=json.load(sys.stdin); print(d.get('tool_input',{}).get('command',''))" 2>/dev/null || echo "")

# Only check on git add or git commit commands
if ! echo "$COMMAND" | grep -qE "git (add|commit)"; then
  echo '{"decision":"approve"}'
  exit 0
fi

# Find the git root directory
GIT_ROOT=$(git rev-parse --show-toplevel 2>/dev/null || echo "")
if [ -z "$GIT_ROOT" ]; then
  echo '{"decision":"approve"}'
  exit 0
fi

# Check if this is a Unity project (has Assets/ folder or ProjectSettings/ folder)
if [ ! -d "$GIT_ROOT/Assets" ] && [ ! -d "$GIT_ROOT/ProjectSettings" ]; then
  echo '{"decision":"approve"}'
  exit 0
fi

# --- This is a Unity project. Check .gitignore. ---

GITIGNORE="$GIT_ROOT/.gitignore"

# Case 1: No .gitignore at all
if [ ! -f "$GITIGNORE" ]; then
  PLUGIN_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]:-$0}")/.." && pwd)"
  TEMPLATE="$PLUGIN_ROOT/references/unity-gitignore-template.txt"

  cat <<EOF
{
  "decision": "block",
  "reason": "Unity project has no .gitignore file. Without it, Library/, Temp/, and build artifacts (hundreds of MB) will be committed. Create .gitignore first using the template at: ${TEMPLATE}"
}
EOF
  exit 0
fi

# Case 2: .gitignore exists but is missing critical Unity entries
CRITICAL_PATTERNS=(
  "[Ll]ibrary/"
  "[Tt]emp/"
  "[Oo]bj/"
  "[Bb]uild/"
  "[Ll]ogs/"
)

MISSING=()
for pattern in "${CRITICAL_PATTERNS[@]}"; do
  if ! grep -q "$pattern" "$GITIGNORE" 2>/dev/null; then
    MISSING+=("$pattern")
  fi
done

if [ ${#MISSING[@]} -gt 0 ]; then
  MISSING_LIST=$(printf '%s, ' "${MISSING[@]}" | sed 's/, $//')
  cat <<EOF
{
  "decision": "block",
  "reason": "Unity .gitignore is missing critical entries: ${MISSING_LIST}. These directories contain generated files (hundreds of MB) that must not be committed. Update .gitignore before proceeding."
}
EOF
  exit 0
fi

# .gitignore looks good
echo '{"decision":"approve"}'
exit 0
