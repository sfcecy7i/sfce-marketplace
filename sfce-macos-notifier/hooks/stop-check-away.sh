#!/bin/bash
# Stop Hook: Clean up session files

# Read JSON input from stdin
INPUT=$(cat)

# Extract session_id
SESSION_ID=$(echo "$INPUT" | python3 -c "import sys, json; print(json.load(sys.stdin).get('session_id', 'unknown'))" 2>/dev/null || echo "unknown")

# Cleanup monitor and timestamp files
TIMESTAMP_FILE="/tmp/claude-session-${SESSION_ID}.txt"
MONITOR_FILE="/tmp/claude-monitor-${SESSION_ID}.txt"

rm -f "$TIMESTAMP_FILE"
rm -f "$MONITOR_FILE"

exit 0
