#!/bin/bash
# PostToolUse Hook: Send notification after long-running or failed Bash commands

# Read JSON input from stdin
INPUT=$(cat)

# Extract information using Python (more reliable than jq)
COMMAND=$(echo "$INPUT" | python3 -c "import sys, json; print(json.load(sys.stdin).get('tool_input', {}).get('command', 'N/A'))" 2>/dev/null || echo "N/A")

# Check if terminal-notifier is available
if ! command -v terminal-notifier &> /dev/null; then
    exit 0  # Silent exit if terminal-notifier not installed
fi

# Send notification
terminal-notifier -title "Claude Code" -message "命令完成: $COMMAND" -sound default

exit 0
