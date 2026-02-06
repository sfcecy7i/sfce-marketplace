---
description: Send MacOS system notification
argument-hint: [title] [message] [level]
allowed-tools: Bash(terminal-notifier:*), Read
---

You are executing a command to send a MacOS system notification. Follow these steps:

**Step 1: Check terminal-notifier is installed**

Execute: !`which terminal-notifier`

If the command returns "NOT_FOUND" or fails, inform the user:
- terminal-notifier is not installed
- They need to install it: `brew install terminal-notifier`
- Then stop.

**Step 2: Validate arguments**

You have been given these arguments:
- $1 = title (notification title)
- $2 = message (notification message)
- $3 = level (optional: info|success|warning|error, default: info)

If $1 or $2 are empty, ask the user to provide both title and message.

**Step 3: Send the notification**

Execute the notification command:
!terminal-notifier -title "$1" -message "$2" -sound default

**Step 4: Confirm to user**

After sending the notification, inform the user:
- "Notification sent: [title]"
- If the notification level was success/error, provide appropriate context

That's it. Do not add additional features or behaviors.
