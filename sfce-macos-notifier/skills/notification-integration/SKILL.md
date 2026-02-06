---
name: notification-integration
description: Technical implementation guide for sending notifications via terminal-notifier (system) and SMTP (email). Use this skill when implementing notification commands or integrating notification capabilities into workflows.
version: 0.1.0
---

# Notification Integration Guide

This skill provides technical implementation details for sending system and email notifications in Claude Code.

## Configuration

### Configuration File Location

Configuration is read from the first available location (in priority order):

1. **Project config:** `.claude/sfce-macos-notifier.local.md`
2. **User config:** `~/.claude/sfce-macos-notifier.local.md`
3. **Default reference:** `${CLAUDE_PLUGIN_ROOT}/skills/notification-integration/default-config.md`

### Configuration Format

Create configuration file in YAML format:

```yaml
# smtp: smtp.189.cn
# smtp_port: 465
# smtp_user: zyzj_yyhx@189.cn
# smtp_password: nE(9xY!9V*9lS@0m
# smtp_from: zyzj_yyhx@189.cn
# default_recipient: 18703970603@139.com

# enable_system_notification: true
# enable_email_notification: false
# default_sound: true

# min_task_duration: 10  # Minimum task duration (seconds) to trigger notification
```

## System Notifications

### Implementation

System notifications use `terminal-notifier` command-line tool.

**Check availability:**
```bash
which terminal-notifier
```

**Install if missing:**
```bash
brew install terminal-notifier
```

**Send notification:**
```bash
terminal-notifier -title "标题" -message "消息内容" -sound default
```

### Supported Parameters

- `-title`: Notification title (required)
- `-message`: Notification message (required)
- `-sound`: Sound to play (default, default, etc.)
- `-subtitle`: Subtitle text
- `-contentImage`: Path to image to display
- `-open`: URL to open on click
- `-execute`: Shell command to execute on click

### Error Handling

If terminal-notifier is not installed:
1. Inform user about missing dependency
2. Provide installation command
3. Continue execution (notification is best-effort)

## Email Notifications

### Implementation

Email notifications use Python script with SMTP_SSL.

**Script location:** `${CLAUDE_PLUGIN_ROOT}/skills/notification-integration/scripts/send-email.py`

**Usage:**
```bash
python3 send-email.py --subject "主题" --body "内容" --level "info" --config /path/to/config
```

### Email Format

Plain text format with structured content:

```
Subject: [Claude Code - INFO] 邮件主题

通知时间：2025-02-06 12:30:00
通知级别：INFO
项目路径：/path/to/project

邮件内容...

---
此邮件由 Claude Code 自动发送
```

### SMTP Configuration

**SMTP_SSL** (port 465):
```python
server = smtplib.SMTP_SSL(host, port)
server.login(user, password)
server.sendmail(from_addr, to_addr, msg.as_string())
server.quit()
```

**Required parameters:**
- smtp_host: SMTP server address
- smtp_port: SMTP server port (465 for SSL)
- smtp_user: SMTP username
- smtp_password: SMTP password
- smtp_from: From email address
- default_recipient: Default recipient email

### Error Handling

Script handles:
- Missing configuration files
- Invalid SMTP credentials
- Network errors
- Invalid email addresses

Returns appropriate error messages for debugging.

## Script Details

### send-email.py

**Purpose:** Send email notifications via SMTP

**Arguments:**
- `--subject`: Email subject
- `--body`: Email body content
- `--level`: Notification level (info/success/warning/error)
- `--config`: Path to configuration file

**Output:**
- Success: Prints confirmation
- Failure: Prints error details

**Exit codes:**
- 0: Success
- 1: Configuration error
- 2: SMTP error
- 3: Network error

### check-dependencies.sh

**Purpose:** Check if required dependencies are installed

**Checks:**
- `terminal-notifier` availability
- Python 3 availability
- Required Python packages

**Usage:**
```bash
bash check-dependencies.sh
```

## Integration Patterns

### Pattern 1: Read Configuration

Read configuration files in priority order:

```python
import yaml
import os

config_paths = [
    '.claude/sfce-macos-notifier.local.md',
    os.path.expanduser('~/.claude/sfce-macos-notifier.local.md'),
    'default-config.md'
]

for path in config_paths:
    if os.path.exists(path):
        with open(path) as f:
            config = yaml.safe_load(f)
        break
```

### Pattern 2: Validate Before Sending

Always validate configuration before attempting to send:

```bash
# Check config exists
test -f config_file || echo "Config not found"

# Validate required fields
grep -q "smtp_host" config_file || echo "Missing smtp_host"
```

### Pattern 3: Graceful Degradation

If email sending fails, don't fail the entire workflow:

```bash
# Try to send email
python3 send-email.py ... || echo "Email notification failed"

# Continue with system notification
terminal-notifier -title "标题" -message "消息"
```

## Environment Variables

- `${CLAUDE_PLUGIN_ROOT}`: Plugin root directory (automatically set)
- `${PWD}`: Current working directory
- `${HOME}`: User home directory

## Debugging

### System Notifications

**Check if terminal-notifier works:**
```bash
terminal-notifier -title "Test" -message "Test notification"
```

**Check sound:**
```bash
terminal-notifier -sound default -title "Test" -message "Test sound"
```

### Email Notifications

**Test SMTP connection:**
```python
python3 -c "import smtplib; s = smtplib.SMTP_SSL('smtp.189.cn', 465); s.quit()"
```

**Test script manually:**
```bash
python3 send-email.py --subject "Test" --body "Test email" --level "info"
```

**Check Python version:**
```bash
python3 --version
```

## Security Considerations

### Credentials

- Never hardcode credentials in commands or scripts
- Always read from configuration files
- Use environment variables for sensitive data
- Add `.claude/*.local.md` to `.gitignore`

### Permissions

Configuration files may contain sensitive information:
- Ensure proper file permissions (600 for user configs)
- Don't commit configuration files with real credentials
- Provide example configuration with placeholder values

## Related Components

- **Commands:** `/send-system-notification`, `/send-email-notification`, `/send-both-notifications`
- **Skills:** `notification-usage` - When and how to send notifications
- **Hooks:** Automatic notification triggers

## See Also

- terminal-notifier documentation: `man terminal-notifier`
- Python smtplib documentation: https://docs.python.org/3/library/smtplib.html
