#!/bin/bash
# Idle Monitor: Background process that monitors user activity during idle/permission prompts
# Started by notification-attention.sh, stopped by user-activity.sh

INPUT=$(cat)
SESSION_ID=$(echo "$INPUT" | python3 -c "import sys, json; print(json.load(sys.stdin).get('session_id', 'unknown'))" 2>/dev/null || echo "unknown")

# Function to read config value
read_config() {
    local key="$1"
    local config_file="$2"

    if [ ! -f "$config_file" ]; then
        echo ""
        return
    fi

    grep "^${key}:" "$config_file" | sed 's/.*: *//' | tr -d '\r'
}

# Find config file
CONFIG_FILE=""
if [ -f ".claude/sfce-macos-notifier.local.md" ]; then
    CONFIG_FILE=".claude/sfce-macos-notifier.local.md"
elif [ -f "$HOME/.claude/sfce-macos-notifier.local.md" ]; then
    CONFIG_FILE="$HOME/.claude/sfce-macos-notifier.local.md"
else
    CONFIG_FILE="${CLAUDE_PLUGIN_ROOT}/skills/notification-integration/default-config.md"
fi

# Check if email notifications are enabled
EMAIL_ENABLED=$(read_config "enable_email_notification" "$CONFIG_FILE")
if [ "$EMAIL_ENABLED" != "true" ]; then
    exit 0
fi

# Get idle timeout
IDLE_TIMEOUT=$(read_config "idle_timeout_minutes" "$CONFIG_FILE")
if [ -z "$IDLE_TIMEOUT" ] || [ "$IDLE_TIMEOUT" = "0" ]; then
    exit 0
fi

# Monitor file
MONITOR_FILE="/tmp/claude-monitor-${SESSION_ID}.txt"
TIMESTAMP_FILE="/tmp/claude-session-${SESSION_ID}.txt"

# Create monitor file with start time
echo "$(date +%s)" > "$MONITOR_FILE"

# Monitor in background
(
    while true; do
        sleep 10  # Check every 10 seconds

        # Check if monitor was stopped (file deleted)
        if [ ! -f "$MONITOR_FILE" ]; then
            exit 0
        fi

        # Calculate idle time
        if [ -f "$TIMESTAMP_FILE" ]; then
            LAST_ACTIVITY=$(head -1 "$TIMESTAMP_FILE")
            MONITOR_START=$(head -1 "$MONITOR_FILE")
            CURRENT_TIME=$(date +%s)

            # Use the earlier of: last activity or monitor start
            ACTIVITY_START=$((LAST_ACTIVITY < MONITOR_START ? LAST_ACTIVITY : MONITOR_START))
            IDLE_SECONDS=$((CURRENT_TIME - ACTIVITY_START))
            IDLE_MINUTES=$((IDLE_SECONDS / 60))

            # Check if timeout exceeded
            if [ "$IDLE_MINUTES" -ge "$IDLE_TIMEOUT" ]; then
                # Send email notification
                if command -v terminal-notifier &> /dev/null; then
                    terminal-notifier -title "Claude Code" -message "📧 已发送邮件通知" -sound default
                fi

                python3 "${CLAUDE_PLUGIN_ROOT}/skills/notification-integration/scripts/send-email.py" \
                    --subject "Claude Code 等待您的响应" \
                    --body "Claude Code 正在等待您的输入或权限确认，您已超过 ${IDLE_TIMEOUT} 分钟未响应。请回到电脑前继续操作。" \
                    --level "warning" \
                    --config "$CONFIG_FILE"

                # Stop monitoring after sending email
                rm -f "$MONITOR_FILE"
                exit 0
            fi
        fi
    done
) &

exit 0
