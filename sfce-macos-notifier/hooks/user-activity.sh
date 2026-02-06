#!/bin/bash
# UserPromptSubmit Hook: Update user activity timestamp and stop idle monitor

# Read JSON input from stdin
INPUT=$(cat)

# Extract session_id
SESSION_ID=$(echo "$INPUT" | python3 -c "import sys, json; print(json.load(sys.stdin).get('session_id', 'unknown'))" 2>/dev/null || echo "unknown")

# Update timestamp file
TIMESTAMP_FILE="/tmp/claude-session-${SESSION_ID}.txt"
if [ -f "$TIMESTAMP_FILE" ]; then
    echo "$(date +%s)" > "$TIMESTAMP_FILE"
    echo "LAST_ACTIVITY: $(date)" >> "$TIMESTAMP_FILE"
fi

# Stop idle monitor (user is active again)
MONITOR_FILE="/tmp/claude-monitor-${SESSION_ID}.txt"
rm -f "$MONITOR_FILE"

exit 0
