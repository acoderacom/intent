#!/bin/bash
# Auto-approve intent-turso commands to skip permission prompts
set -euo pipefail

input=$(cat)
command=$(echo "$input" | jq -r '.tool_input.command')

# Auto-approve intent-turso commands (including heredocs piped to intent-turso)
if [[ "$command" =~ npx\ intent-turso ]]; then
  jq -n '{
    hookSpecificOutput: {
      hookEventName: "PreToolUse",
      permissionDecision: "allow",
      permissionDecisionReason: "Auto-approved intent-turso command"
    }
  }'
  exit 0
fi

# Pass through other commands (let Claude handle normally)
exit 0
