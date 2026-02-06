---
description: Send email notification via SMTP
argument-hint: [subject] [body] [level]
allowed-tools: Bash(python3:*), Read
---

You are executing a command to send an email notification. Follow these steps:

**Step 1: Validate arguments**

You have been given:
- $1 = subject (email subject)
- $2 = body (email body content)
- $3 = level (optional: info|success|warning|error, default: info)

If $1 or $2 are empty, ask the user to provide both subject and body.

**Step 2: Find configuration file**

Check configuration files in this order:
1. Project config: `.claude/sfce-macos-notifier.local.md`
2. User config: `~/.claude/sfce-macos-notifier.local.md`
3. Default config: `${CLAUDE_PLUGIN_ROOT}/skills/notification-integration/default-config.md`

Read the first one that exists. If none exist, inform the user:
- Email notification requires configuration
- Create a config file at ~/.claude/sfce-macos-notifier.local.md
- Show them the template from the default config file
- Then stop.

**Step 3: Check if email notifications are enabled**

From the config, check `enable_email_notification`. If it's false or not set to true:
- Inform user that email notifications are disabled
- Tell them to set `enable_email_notification: true` in their config
- Then stop.

**Step 4: Execute the Python script**

Run the email script with the loaded config:
!python3 ${CLAUDE_PLUGIN_ROOT}/skills/notification-integration/scripts/send-email.py "$1" "$2" "$3"

**Step 5: Report result**

If successful: "Email sent successfully"
If failed: Show the error message from the script

That's it. Do not add additional behaviors.
