---
description: Send MacOS system notification
argument-hint: [title] [message] [level]
allowed-tools: Bash(terminal-notifier:*), Read
---

Send MacOS system notification using terminal-notifier.

**Parameters:**
- $1 (title): Notification title
- $2 (message): Notification message
- $3 (level): info|success|warning|error (default: info)

**Usage:**
```
/send-system-notification "任务完成" "所有测试通过" "success"
/send-system-notification "构建失败" "请检查错误日志" "error"
/send-system-notification "需要确认" "请在弹窗中确认" "warning"
```

**Implementation:**

1. Check terminal-notifier availability: !`which terminal-notifier || echo "NOT_FOUND"`

2. If terminal-notifier not installed:
   - Inform user they need to install it
   - Provide installation command: `brew install terminal-notifier`

3. If available, send notification:
```
!terminal-notifier -title "$1" -message "$2" -sound default
```

4. Map notification levels to appropriate sounds/icons:
   - info: default sound
   - success: default sound
   - warning: default sound
   - error: default sound

5. Confirm notification sent to user.
