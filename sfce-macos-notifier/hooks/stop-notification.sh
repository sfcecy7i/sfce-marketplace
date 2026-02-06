#!/bin/bash
# Stop Hook: Send notification when Claude Code session ends

# Read JSON input from stdin
INPUT=$(cat)
CLAUDE_PLUGIN_ROOT="$1"

# Check if stop notification is enabled
CONFIG_FILE="$HOME/.claude/sfce-macos-notifier.local.md"
if [ ! -f "$CONFIG_FILE" ]; then
    CONFIG_FILE="${CLAUDE_PLUGIN_ROOT}/skills/notification-integration/default-config.md"
fi

# Check if enable_stop_notification is true (disabled by default)
if grep -q "enable_stop_notification: true" "$CONFIG_FILE" 2>/dev/null; then
    # Check if terminal-notifier is available
    if command -v terminal-notifier &> /dev/null; then
        terminal-notifier -title "Claude Code" -message "会话已结束" -sound default
    fi
fi

exit 0
