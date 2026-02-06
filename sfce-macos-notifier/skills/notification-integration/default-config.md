---
# Default Configuration for sfce-macos-notifier
#
# This is a template configuration file.
# To customize, copy this file to one of these locations:
#   1. Project-specific: .claude/sfce-macos-notifier.local.md
#   2. User-level:     ~/.claude/sfce-macos-notifier.local.md
#
# Configuration priority: Project > User > Default (this file)
---

# SMTP Configuration (for email notifications)
# Uncomment and configure these values to enable email notifications

# smtp: smtp.189.cn
# smtp_port: 465
# smtp_user: your-email@189.cn
# smtp_password: your-password
# smtp_from: your-email@189.cn
# default_recipient: recipient@example.com

# Notification Preferences

# Enable/disable system notifications (default: true)
# System notifications use terminal-notifier on macOS
enable_system_notification: true

# Enable/disable email notifications (default: false)
# Requires SMTP configuration above
enable_email_notification: false

# Play sound with system notifications (default: true)
default_sound: true

# Minimum task duration (in seconds) to trigger automatic notification
# Tasks shorter than this will not trigger PostToolUse notifications
# Default: 10 seconds
min_task_duration: 10

# Enable notification on session stop (default: false)
# When enabled, sends notification when Claude Code session ends
enable_stop_notification: false

# Away Mode & Idle Timeout (for smart email notifications)
# ---------------------------------------------------------
# Manual away mode: when true, always send email on session stop
# Use this when you're leaving your computer and want email notifications
away_mode: false

# Idle timeout: send email if no user activity for this many minutes
# Set to 0 to disable idle timeout checking
# Default: 30 minutes
idle_timeout_minutes: 30

# Notification Levels
# -------------------
# info:    General informational messages
# success: Successful completion of tasks
# warning: Issues that need attention but aren't critical
# error:   Critical failures requiring immediate attention

# Configuration File Format
# --------------------------
# This file uses YAML format. Lines starting with # are comments.
# Uncomment lines by removing the # prefix and provide your values.
