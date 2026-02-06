#!/bin/bash
# UserPromptSubmit Hook: Update user activity timestamp AND detect presence

# Read JSON input from stdin
INPUT=$(cat)

# Extract session_id and prompt
SESSION_ID=$(echo "$INPUT" | python3 -c "import sys, json; print(json.load(sys.stdin).get('session_id', 'unknown'))" 2>/dev/null || echo "unknown")
PROMPT=$(echo "$INPUT" | python3 -c "import sys, json; print(json.load(sys.stdin).get('prompt', ''))" 2>/dev/null || echo "")

# Update timestamp file
TIMESTAMP_FILE="/tmp/claude-session-${SESSION_ID}.txt"
if [ -f "$TIMESTAMP_FILE" ]; then
    echo "$(date +%s)" > "$TIMESTAMP_FILE"
    echo "LAST_ACTIVITY: $(date)" >> "$TIMESTAMP_FILE"
fi

# ========== 智能状态检测 ==========
CONFIG_FILE="$HOME/.claude/sfce-macos-notifier.local.md"

# 离开关键词（匹配中文和英文）
LEAVING_KEYWORDS="我要去|我先走了|待会儿见|晚点说|去休息|去开会|我有事|一会再回|leaving|see you|BRB|away from keyboard|gone|afk"

# 返回关键词
RETURNING_KEYWORDS="我回来了|继续|我们继续|现在可以了|I'm back|Let's continue|Ready to continue|继续工作"

# 检测是否要离开
if echo "$PROMPT" | grep -qiE "$LEAVING_KEYWORDS"; then
    # 启用 away_mode
    if [ -f "$CONFIG_FILE" ]; then
        if grep -q "^away_mode:" "$CONFIG_FILE"; then
            sed -i '' 's/^away_mode:.*/away_mode: true/' "$CONFIG_FILE"
        else
            echo -e "\naway_mode: true" >> "$CONFIG_FILE"
        fi
    else
        echo -e "---\naway_mode: true\n" > "$CONFIG_FILE"
    fi
    echo "📧 已启用离开模式，会话结束时会发送邮件通知" >&2
fi

# 检测是否返回
if echo "$PROMPT" | grep -qiE "$RETURNING_KEYWORDS"; then
    # 禁用 away_mode
    if [ -f "$CONFIG_FILE" ]; then
        if grep -q "^away_mode:" "$CONFIG_FILE"; then
            sed -i '' 's/^away_mode:.*/away_mode: false/' "$CONFIG_FILE"
        else
            echo -e "\naway_mode: false" >> "$CONFIG_FILE"
        fi
    else
        echo -e "---\naway_mode: false\n" > "$CONFIG_FILE"
    fi
    echo "✅ 已返回在电脑模式，邮件通知已禁用" >&2
fi

exit 0
