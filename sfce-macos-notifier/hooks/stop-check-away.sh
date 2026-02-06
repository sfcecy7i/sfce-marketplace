#!/bin/bash
# Stop Hook: Check away mode and idle timeout, send email if needed

# Read JSON input from stdin
INPUT=$(cat)

# Extract session_id
SESSION_ID=$(echo "$INPUT" | python3 -c "import sys, json; print(json.load(sys.stdin).get('session_id', 'unknown'))" 2>/dev/null || echo "unknown")

TIMESTAMP_FILE="/tmp/claude-session-${SESSION_ID}.txt"

# Function to read config value
read_config() {
    local key="$1"
    local config_file="$2"

    if [ ! -f "$config_file" ]; then
        echo ""
        return
    fi

    # Extract value (handles both value: true and value: false)
    grep "^${key}:" "$config_file" | sed 's/.*: *//' | tr -d '\r'
}

# Find config file
CONFIG_FILE=""
if [ -f ".claude/sfce-macos-notifier.local.md" ]; then
    CONFIG_FILE=".claude/sfce-macos-notifier.local.md"
elif [ -f "$HOME/.claude/sfce-macos-notifier.local.md" ]; then
    CONFIG_FILE="$HOME/.claude/sfce-macos-notifier.local.md"
else
    # Use plugin root
    CONFIG_FILE="${CLAUDE_PLUGIN_ROOT}/skills/notification-integration/default-config.md"
fi

# Check if email notifications are enabled
EMAIL_ENABLED=$(read_config "enable_email_notification" "$CONFIG_FILE")
if [ "$EMAIL_ENABLED" != "true" ]; then
    exit 0
fi

# Check away_mode (方案 C)
AWAY_MODE=$(read_config "away_mode" "$CONFIG_FILE")
SEND_EMAIL=false

if [ "$AWAY_MODE" = "true" ]; then
    # Manual away mode is enabled
    SEND_EMAIL=true
else
    # Check idle timeout (方案 B)
    IDLE_TIMEOUT=$(read_config "idle_timeout_minutes" "$CONFIG_FILE")
    if [ -n "$IDLE_TIMEOUT" ] && [ "$IDLE_TIMEOUT" != "0" ]; then
        if [ -f "$TIMESTAMP_FILE" ]; then
            LAST_ACTIVITY=$(head -1 "$TIMESTAMP_FILE")
            CURRENT_TIME=$(date +%s)
            IDLE_SECONDS=$((CURRENT_TIME - LAST_ACTIVITY))
            IDLE_MINUTES=$((IDLE_SECONDS / 60))

            if [ "$IDLE_MINUTES" -ge "$IDLE_TIMEOUT" ]; then
                SEND_EMAIL=true
            fi
        fi
    fi
fi

# Send email if needed
if [ "$SEND_EMAIL" = "true" ]; then
    # Check if terminal-notifier is available for system notification
    if command -v terminal-notifier &> /dev/null; then
        terminal-notifier -title "Claude Code" -message "📧 已发送邮件通知" -sound default
    fi

    # Send email using Python script
    if [ -f "${CLAUDE_PLUGIN_ROOT}/skills/notification-integration/scripts/send-email.py" ]; then
        python3 "${CLAUDE_PLUGIN_ROOT}/skills/notification-integration/scripts/send-email.py" \
            "Claude Code 会话通知" \
            "Claude Code 会话已结束。你处于离开模式或空闲时间已超过阈值。" \
            "info"
    fi
fi

# Cleanup timestamp file
rm -f "$TIMESTAMP_FILE"

exit 0
