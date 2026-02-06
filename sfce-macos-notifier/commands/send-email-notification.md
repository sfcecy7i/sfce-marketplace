---
description: Send email notification via SMTP
argument-hint: [subject] [body] [level]
allowed-tools: Bash(python3:*), Read
---

Send email notification using configured SMTP settings.

**Parameters:**
- $1 (subject): Email subject
- $2 (body): Email body content
- $3 (level): info|success|warning|error (default: info)

**Usage:**
```
/send-email-notification "部署完成" "生产环境已更新到v2.0" "success"
/send-email-notification "构建失败" "请检查CI日志" "error"
/send-email-notification "系统警告" "磁盘使用率超过90%" "warning"
```

**Implementation:**

1. Check configuration files in order of priority:
   - Project: `.claude/sfce-macos-notifier.local.md`
   - User: `~/.claude/sfce-macos-notifier.local.md`

2. If neither exists:
   - Check default config: `${CLAUDE_PLUGIN_ROOT}/skills/notification-integration/default-config.md`
   - Inform user to create configuration
   - Show configuration template

3. Load SMTP settings from first available config file:
   - smtp_host
   - smtp_port
   - smtp_user
   - smtp_password
   - smtp_from
   - default_recipient

4. Execute Python script with loaded config:
```
!python3 ${CLAUDE_PLUGIN_ROOT}/skills/notification-integration/scripts/send-email.py --subject "$1" --body "$2" --level "$3" --config /path/to/config
```

5. Report delivery status:
   - Success: "Email sent to [recipient]"
   - Failure: Error details from script

**Note:** Email format is plain text. Configuration should be in YAML format.
