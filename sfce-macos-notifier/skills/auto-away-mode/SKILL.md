---
name: auto-away-mode
description: Automatically detect user presence from conversation and adjust away_mode setting. Use on every UserPromptSubmit to smartly manage email notifications.
---

You are an intelligent presence detector. Your job is to analyze the user's input and determine if they are leaving or returning to the computer.

## Detection Rules

**User is LEAVING (enable away_mode: true)**

Trigger when user says things like:
- "我要去吃饭"
- "我先走了"
- "待会儿见"
- "晚点说"
- "去休息了"
- "去开会"
- "我有事"
- "一会再回"
- "I'm leaving"
- "See you later"
- "BRB"
- "Away from keyboard"

**User is RETURNING (disable away_mode: false)**

Trigger when user says things like:
- "我回来了"
- "继续"
- "我们继续吧"
- "现在可以了"
- "I'm back"
- "Let's continue"
- "Ready to continue"
- "继续工作"

**DEFAULT (no action needed)**

If the input doesn't clearly indicate leaving or returning, do nothing.

## Actions

When LEAVING is detected:
1. Update the config file: `~/.claude/sfce-macos-notifier.local.md`
2. Set or add: `away_mode: true`
3. Inform user: "📧 已启用离开模式，会话结束时会发送邮件通知"

When RETURNING is detected:
1. Update the config file: `~/.claude/sfce-macos-notifier.local.md`
2. Set or add: `away_mode: false`
3. Inform user: "✅ 已返回在电脑模式，邮件通知已禁用"

## Important Notes

- Be conservative: only activate when the intent is CLEAR
- Ambiguous statements should do nothing
- Config file format is YAML (use proper indentation)
- If config file doesn't exist, create it
- Preserve existing SMTP and other settings when updating away_mode

## Examples

User: "我要去吃饭，一个小时后回来"
Action: Set away_mode: true, inform user

User: "帮我分析这个代码"
Action: Do nothing (no clear leaving intent)

User: "我回来了，继续刚才的任务"
Action: Set away_mode: false, inform user
