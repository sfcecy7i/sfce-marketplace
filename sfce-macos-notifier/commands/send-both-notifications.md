---
description: Send both system and email notifications
argument-hint: [title] [message] [level]
allowed-tools: Bash(terminal-notifier:*), Bash(python3:*), Read
---

Send both MacOS system notification and email notification.

**Parameters:**
- $1 (title): Title for notifications
- $2 (message): Message content
- $3 (level): info|success|warning|error (default: info)

**Usage:**
```
/send-both-notifications "任务完成" "所有测试通过，代码已部署" "success"
/send-both-notifications "严重错误" "生产环境无法访问" "error"
/send-both-notifications "提醒" "会议将在15分钟后开始" "info"
```

**Implementation:**

1. **Load configuration** (same priority as send-email-notification):
   - Check project config: `.claude/sfce-macos-notifier.local.md`
   - Check user config: `~/.claude/sfce-macos-notifier.local.md`
   - Use default if available

2. **Send system notification** (doesn't require email config):
```
!terminal-notifier -title "$1" -message "$2" -sound default
```

3. **Send email notification** (requires email config):
```
!python3 ${CLAUDE_PLUGIN_ROOT}/skills/notification-integration/scripts/send-email.py --subject "$1" --body "$2" --level "$3" --config /path/to/config
```

4. **Report status for both channels**:
   - System notification: ✓ Sent
   - Email notification: ✓ Sent to [recipient] / ✗ Skipped (no config)

**Note:** System notification will always be sent. Email notification requires SMTP configuration.
