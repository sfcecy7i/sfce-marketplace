# sfce-macos-notifier

Claude Code plugin for sending MacOS system notifications and email notifications.

## Features

- **System Notifications**: Send MacOS notifications using `terminal-notifier`
- **Email Notifications**: Send email notifications via SMTP_SSL (port 465)
- **Four Notification Levels**: info, success, warning, error
- **Automatic Hooks**: Notify on long-running task completion
- **Flexible Configuration**: Project, user, or default config priority

## Installation

### Option 1: Local Testing (Recommended for Development)

Use the `--plugin-dir` flag to test the plugin during development:

```bash
claude --plugin-dir /Users/sfce/.claude/plugins/sfce-macos-notifier
```

**Note**: Changes to the plugin require restarting Claude Code to take effect.

### Option 2: Create a Local Marketplace

Create a marketplace file to install the plugin like a marketplace plugin:

1. **Create a marketplace directory**:
```bash
mkdir -p ~/claude-plugins-marketplace
cd ~/claude-plugins-marketplace
```

2. **Copy the plugin**:
```bash
cp -r /Users/sfce/.claude/plugins/sfce-macos-notifier .
```

3. **Create marketplace.json**:
```bash
mkdir -p .claude-plugin
cat > .claude-plugin/marketplace.json << 'EOF'
{
  "name": "local-plugins",
  "owner": {
    "name": "Local User"
  },
  "plugins": [
    {
      "name": "sfce-macos-notifier",
      "source": "./sfce-macos-notifier",
      "description": "MacOS system and email notifications for Claude Code",
      "version": "1.0.0"
    }
  ]
}
EOF
```

4. **Add marketplace in Claude Code**:
```bash
/plugin marketplace add ~/claude-plugins-marketplace
```

5. **Install the plugin**:
```bash
/plugin install sfce-macos-notifier@local-plugins
```

6. **Restart Claude Code** to load the plugin

### Option 3: GitHub Marketplace (For Distribution)

1. **Push plugin to GitHub**:
```bash
cd /Users/sfce/.claude/plugins/sfce-macos-notifier
git init
git add .
git commit -m "Initial commit"
gh repo create sfce-macos-notifier --public --source=.
git push -u origin main
```

2. **Create marketplace repository** (separate repo for marketplace):
```bash
cd ~
mkdir sfce-notifier-marketplace
cd sfce-notifier-marketplace
mkdir -p .claude-plugin
cat > .claude-plugin/marketplace.json << 'EOF'
{
  "name": "sfce-notifier-marketplace",
  "owner": {
    "name": "Your Name"
  },
  "plugins": [
    {
      "name": "sfce-macos-notifier",
      "source": {
        "source": "github",
        "repo": "YOUR_USERNAME/sfce-macos-notifier"
      },
      "description": "MacOS system and email notifications for Claude Code"
    }
  ]
}
EOF
git init
git add .
git commit -m "Create marketplace"
gh repo create sfce-notifier-marketplace --public --source=.
git push -u origin main
```

3. **Install from marketplace**:
```bash
/plugin marketplace add YOUR_USERNAME/sfce-notifier-marketplace
/plugin install sfce-macos-notifier@sfce-notifier-marketplace
```

## Prerequisites

### Required

- **macOS**: For system notifications
- **terminal-notifier**: Install via `brew install terminal-notifier`
- **Python 3**: For email notifications

### Optional (for email notifications)

```bash
pip3 install pyyaml
```

## Usage

### Manual Commands

#### Send System Notification

```bash
/send-system-notification "Title" "Message content" "level"
```

Example:
```bash
/send-system-notification "构建完成" "项目已成功部署" "success"
```

#### Send Email Notification

```bash
/send-email-notification "Subject" "Body content" "level"
```

Example:
```bash
/send-email-notification "测试报告" "所有测试通过" "success"
```

#### Send Both Notifications

```bash
/send-both-notifications "Title" "Message" "level"
```

Example:
```bash
/send-both-notifications "部署完成" "生产环境已更新到 v2.0" "success"
```

### Notification Levels

- `info`: General informational messages
- `success`: Successful completion of tasks
- `warning`: Issues needing attention
- `error`: Critical failures requiring immediate action

## Configuration

### Configuration Priority

1. Project config: `.claude/sfce-macos-notifier.local.md`
2. User config: `~/.claude/sfce-macos-notifier.local.md`
3. Default config: `skills/notification-integration/default-config.md`

### Example Configuration

Create `~/.claude/sfce-macos-notifier.local.md`:

```yaml
---
# SMTP Configuration
smtp: smtp.189.cn
smtp_port: 465
smtp_user: your-email@189.cn
smtp_password: your-password
smtp_from: your-email@189.cn
default_recipient: recipient@example.com

# Notification Preferences
enable_system_notification: true
enable_email_notification: true
default_sound: true
min_task_duration: 10
enable_stop_notification: false
```

### Email Format

Emails are sent in plain text format with the following structure:

```
Subject: [Claude Code - SUCCESS] Subject

通知时间：2025-02-06 14:30:00
通知级别：SUCCESS
项目路径：/path/to/project

Message content

---
此邮件由 Claude Code 自动发送
```

## Automatic Hooks

### PostToolUse Hook

Automatically evaluates Bash commands after execution:
- Checks if command took longer than `min_task_duration` (default: 10 seconds)
- Checks if command succeeded or failed
- Sends appropriate notification if configured

### Stop Hook

Optional notification when Claude Code session ends (disabled by default).

## Troubleshooting

### System Notifications Not Working

```bash
# Check if terminal-notifier is installed
which terminal-notifier

# Install if missing
brew install terminal-notifier

# Test manually
terminal-notifier -title "Test" -message "Test notification"
```

### Email Notifications Not Working

```bash
# Check dependencies
bash /path/to/plugin/skills/notification-integration/scripts/check-dependencies.sh

# Install pyyaml if needed
pip3 install pyyaml

# Verify configuration
cat ~/.claude/sfce-macos-notifier.local.md
```

### Plugin Not Loading

```bash
# Verify plugin files
ls -la ~/.claude/plugins/sfce-macos-notifier/

# Check Claude Code is running
claude --version

# View available commands
/help
```

## Commands

After installation, these commands are available:

- `/send-system-notification`: Send MacOS notification only
- `/send-email-notification`: Send email notification only
- `/send-both-notifications`: Send both system and email notifications

## Skills

The plugin includes two skills for AI guidance:

- **notification-usage**: When and how to send notifications
- **notification-integration**: Technical implementation details

## Development

### Plugin Structure

```
sfce-macos-notifier/
├── .claude-plugin/
│   └── plugin.json          # Plugin manifest
├── commands/                 # Slash commands
│   ├── send-system-notification.md
│   ├── send-email-notification.md
│   └── send-both-notifications.md
├── skills/                   # AI knowledge base
│   ├── notification-usage/
│   │   └── SKILL.md
│   └── notification-integration/
│       ├── SKILL.md
│       ├── default-config.md
│       └── scripts/
│           ├── send-email.py
│           └── check-dependencies.sh
└── hooks/
    └── hooks.json           # Automatic triggers
```

### Running Dependency Check

```bash
bash skills/notification-integration/scripts/check-dependencies.sh
```

## Security

- No hardcoded credentials
- Configuration externalized to `.local.md` files
- Add `.claude/*.local.md` to `.gitignore`
- SMTP credentials stored in user config only

## License

MIT

## Author

Created for Claude Code plugin development.
