---
name: notification-usage
description: Guide for determining when and how to send notifications in Claude Code. Use this skill when tasks complete, errors occur, or users need to be informed about important events.
version: 0.1.0
---

# Notification Usage for Claude Code

This skill provides guidance on when and how to send notifications to users during task execution.

## When to Send Notifications

### Task Completion

Send notifications when tasks complete successfully:

**✅ Notify when:**
- Long-running tasks finish (>10 seconds)
- Multi-step workflows complete
- Deployments succeed
- Tests pass
- Builds complete
- Data processing finishes

**Example usage:**
```
After completing a task that took 15 seconds:
/send-system-notification "构建完成" "项目已成功构建到生产环境" "success"
```

### Errors and Failures

Send notifications when critical errors occur:

**✅ Notify when:**
- Build failures
- Test failures
- Deployment failures
- Script execution errors
- Connection errors
- Data validation failures

**Example usage:**
```
When a deployment fails:
/send-system-notification "部署失败" "无法连接到服务器，请检查网络" "error"
/send-email-notification "部署失败" "详细错误日志：..." "error"
```

### Warnings

Send notifications for non-critical issues that need attention:

**✅ Notify when:**
- Resource usage is high (CPU, memory, disk)
- Deprecated features are used
- Performance degradation detected
- Security vulnerabilities found (low severity)
- Configuration issues detected

**Example usage:**
```
When disk usage exceeds 90%:
/send-system-notification "磁盘警告" "磁盘使用率: 92%" "warning"
```

### User Intervention Required

Send notifications when user action is needed:

**✅ Notify when:**
- Permission required
- Confirmation needed
- Manual review required
- Conflicts detected that need resolution

**Example usage:**
```
When a permission prompt is issued:
/send-system-notification "需要确认" "请在弹窗中授权此操作" "warning"
```

## Notification Levels

### Info (default)
- **Use for:** General informational messages
- **Examples:** Task progress, status updates, reminders
- **User action:** No action required typically

### Success
- **Use for:** Successful completion of tasks
- **Examples:** Deployment success, tests passing, build complete
- **User action:** May want to verify results

### Warning
- **Use for:** Issues that need attention but aren't critical
- **Examples:** Resource warnings, deprecation notices, performance issues
- **User action:** Should investigate soon

### Error
- **Use for:** Critical failures and errors
- **Examples:** Build failures, test failures, connection errors
- **User action:** Immediate attention required

## Choosing Notification Type

### System Notification Only

Use `/send-system-notification` when:
- User is actively working
- Message is time-sensitive
- Immediate attention helpful
- No permanent record needed

### Email Notification Only

Use `/send-email-notification` when:
- User may be away from computer
- Task completed asynchronously
- Permanent record needed
- User is offline or away

### Both Notifications

Use `/send-both-notifications` when:
- Critical task completion
- Important failures
- User might be away
- Both immediate alert and permanent record needed

## Best Practices

### 1. Be Concise and Clear

**Good:**
```
Title: "构建完成"
Message: "项目已成功部署到生产环境 v2.0"
```

**Avoid:**
```
Title: "通知"
Message: "我想告诉你一件事就是构建好像完成了..."
```

### 2. Include Actionable Information

**Good:**
```
Title: "测试失败"
Message: "3个测试失败，运行 npm test 查看详情"
```

**Avoid:**
```
Title: "测试结果"
Message: "有些测试失败了"
```

### 3. Use Appropriate Levels

Don't use "error" for everything. Reserve it for critical issues.

### 4. Consider Timing

Don't spam notifications. Consider:
- Task duration (longer tasks = more important to notify)
- User context (are they waiting for this?)
- Importance (critical vs. nice-to-have)

### 5. Provide Context

Include relevant information in notification message:
- What task completed
- What the result was
- What action (if any) is needed
- Where to find more information

## Common Scenarios

### Scenario 1: Long-Running Build

```
Build started 2 minutes ago and just completed:

/send-system-notification "构建成功" "项目已构建完成，耗时2分15秒" "success"
```

### Scenario 2: Automated Test Failure

```
CI/CD tests failed:

/send-system-notification "测试失败" "5个测试失败，请查看CI日志" "error"
/send-email-notification "测试失败" "详细日志: https://ci.example.com/build/123" "error"
```

### Scenario 3: Deployment

```
Deployment to production completed:

/send-both-notifications "部署完成" "生产环境已更新到v2.0.5" "success"
```

### Scenario 4: Async Background Task

```
Background data processing completed while user was away:

/send-email-notification "数据导入完成" "已成功导入10,000条记录" "success"
```

## Integration with Commands

This skill provides knowledge about when to notify. For actual notification sending, use the appropriate command:

- `/send-system-notification` - MacOS notification
- `/send-email-notification` - Email notification
- `/send-both-notifications` - Both types

## Related Skills

- `notification-integration` - Technical details for sending notifications
- Configuration settings for SMTP and notification preferences
