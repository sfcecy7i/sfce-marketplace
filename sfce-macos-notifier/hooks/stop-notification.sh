#!/bin/bash
# Stop Hook: Send notification when Claude Code session ends

# Read JSON input from stdin
INPUT=$(cat)

# Check if stop notification is enabled (disabled by default, so skip for now)
# To enable, user should set enable_stop_notification: true in their config

# For now, Stop notifications are disabled by default
exit 0
