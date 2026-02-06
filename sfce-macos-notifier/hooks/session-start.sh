#!/bin/bash
# SessionStart Hook: Initialize session tracking

# Read JSON input from stdin
INPUT=$(cat)

# Extract session_id
SESSION_ID=$(echo "$INPUT" | python3 -c "import sys, json; print(json.load(sys.stdin).get('session_id', 'unknown'))" 2>/dev/null || echo "unknown")

# Create timestamp file
TIMESTAMP_FILE="/tmp/claude-session-${SESSION_ID}.txt"
echo "$(date +%s)" > "$TIMESTAMP_FILE"
echo "SESSION_START: $(date)" >> "$TIMESTAMP_FILE"

exit 0
