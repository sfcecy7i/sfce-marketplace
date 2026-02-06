#!/bin/bash
# Notification Hook: Send notification when Claude needs user attention
# Triggered by: permission_prompt, idle_prompt

# Read JSON input from stdin
INPUT=$(cat)

# Extract session_id and notification type
SESSION_ID=$(echo "$INPUT" | python3 -c "import sys, json; print(json.load(sys.stdin).get('session_id', 'unknown'))" 2>/dev/null || echo "unknown")
NOTIFICATION_TYPE=$(echo "$INPUT" | python3 -c "import sys, json; print(json.load(sys.stdin).get('notification_type', 'unknown'))" 2>/dev/null || echo "unknown")

# Check if system notifications are enabled
if grep -q "enable_system_notification: false" ~/.claude/sfce-macos-notifier.local.md 2>/dev/null; then
    exit 0
fi

# Check if terminal-notifier is available
if ! command -v terminal-notifier &> /dev/null; then
    exit 0
fi

# Send notification based on type
case "$NOTIFICATION_TYPE" in
    "permission_prompt")
        terminal-notifier -title "Claude Code" -message "⚠️ 需要权限确认" -sound default
        ;;
    "idle_prompt")
        terminal-notifier -title "Claude Code" -message "🔔 等待您的输入" -sound default
        ;;
    *)
        terminal-notifier -title "Claude Code" -message "👀 需要关注" -sound default
        ;;
esac

# Start idle monitor in background
if [ -f "${CLAUDE_PLUGIN_ROOT}/hooks/idle-monitor.sh" ]; then
    echo "$INPUT" | bash "${CLAUDE_PLUGIN_ROOT}/hooks/idle-monitor.sh"
fi

exit 0
