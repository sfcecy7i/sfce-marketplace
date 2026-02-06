#!/usr/bin/env python3
"""
Send email notification via SMTP.

Usage:
    python3 send-email.py --subject "Subject" --body "Body" --level "info" --config /path/to/config

Arguments:
    --subject: Email subject
    --body: Email body content
    --level: Notification level (info|success|warning|error)
    --config: Path to configuration file

Exit codes:
    0: Success
    1: Configuration error
    2: SMTP error
    3: Network error
"""

import argparse
import os
import sys
from datetime import datetime
import smtplib
from email.mime.text import MIMEText
from email.mime.multipart import MIMEMultipart
from email.utils import formataddr
import yaml


def load_config(config_path):
    """Load configuration from YAML file."""
    if not os.path.exists(config_path):
        print(f"Error: Configuration file not found: {config_path}", file=sys.stderr)
        sys.exit(1)

    with open(config_path, 'r') as f:
        config = yaml.safe_load(f)

    # Validate required fields
    required_fields = ['smtp_host', 'smtp_port', 'smtp_user', 'smtp_password', 'smtp_from', 'default_recipient']
    missing_fields = [field for field in required_fields if field not in config]

    if missing_fields:
        print(f"Error: Missing required configuration fields: {', '.join(missing_fields)}", file=sys.stderr)
        sys.exit(1)

    return config


def send_email(subject, body, level, config):
    """Send email notification via SMTP."""
    try:
        # Create message
        msg = MIMEMultipart('alternative')
        msg['Subject'] = f"[Claude Code - {level.upper()}] {subject}"
        msg['From'] = formataddr(('Claude Code', config['smtp_from']))
        msg['To'] = formataddr(('User', config['default_recipient']))

        # Plain text email body
        email_body = f"""通知时间：{datetime.now().strftime('%Y-%m-%d %H:%M:%S')}
通知级别：{level.upper()}
项目路径：{os.getcwd()}

{body}

---
此邮件由 Claude Code 自动发送"""

        text_part = MIMEText(email_body, 'plain', 'utf-8')
        msg.attach(text_part)

        # Send email using SMTP_SSL for port 465
        smtp_host = config['smtp_host']
        smtp_port = int(config['smtp_port'])

        server = smtplib.SMTP_SSL(smtp_host, smtp_port)
        server.login(config['smtp_user'], config['smtp_password'])
        server.sendmail(config['smtp_from'], [config['default_recipient']], msg.as_string())
        server.quit()

        print(f"✓ Email sent to {config['default_recipient']}")
        return 0

    except smtplib.SMTPAuthenticationError as e:
        print(f"Error: SMTP authentication failed - {e}", file=sys.stderr)
        return 2
    except smtplib.SMTPException as e:
        print(f"Error: SMTP error - {e}", file=sys.stderr)
        return 2
    except Exception as e:
        print(f"Error: Failed to send email - {e}", file=sys.stderr)
        return 3


def main():
    parser = argparse.ArgumentParser(description='Send email notification')
    parser.add_argument('--subject', required=True, help='Email subject')
    parser.add_argument('--body', required=True, help='Email body')
    parser.add_argument('--level', default='info', choices=['info', 'success', 'warning', 'error'], help='Notification level')
    parser.add_argument('--config', required=True, help='Path to configuration file')

    args = parser.parse_args()

    # Load configuration
    config = load_config(args.config)

    # Send email
    exit_code = send_email(args.subject, args.body, args.level, config)
    sys.exit(exit_code)


if __name__ == '__main__':
    main()
