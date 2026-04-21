#!/usr/bin/env bash
# SessionStart hook for superunity plugin

set -euo pipefail

# Determine plugin root directory
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]:-$0}")" && pwd)"
PLUGIN_ROOT="$(cd "${SCRIPT_DIR}/.." && pwd)"

# Read using-superunity content
using_superunity_content=$(cat "${PLUGIN_ROOT}/skills/using-superunity/SKILL.md" 2>&1 || echo "Error reading using-superunity skill")

# Escape string for JSON embedding
escape_for_json() {
    local s="$1"
    s="${s//\\/\\\\}"
    s="${s//\"/\\\"}"
    s="${s//$'\n'/\\n}"
    s="${s//$'\r'/\\r}"
    s="${s//$'\t'/\\t}"
    printf '%s' "$s"
}

using_superunity_escaped=$(escape_for_json "$using_superunity_content")
session_context="You have superunity powers for Unity 3D development.\n\n**Below is your 'superunity:using-superunity' skill — your guide to using Unity development skills. For all other skills, use the Skill tool:**\n\n${using_superunity_escaped}"

# Output context injection as JSON
cat <<EOF
{
  "hookSpecificOutput": {
    "hookEventName": "SessionStart",
    "additionalContext": "${session_context}"
  }
}
EOF

exit 0
