import json
import boto3
import os
from datetime import datetime, timedelta
from collections import defaultdict

sns = boto3.client("sns")


def lambda_handler(event, context):
    print("Processing SQS messages:", json.dumps(event))

    try:
        # Group tasks by assignee
        tasks_by_assignee = defaultdict(list)

        # Process each SQS message
        for record in event["Records"]:
            try:
                task_data = json.loads(record["body"])
                assignee = task_data["assigned_to"]
                tasks_by_assignee[assignee].append(task_data)

                print(f"Processed task for {assignee}: {task_data['title']}")

            except Exception as e:
                print(f"Error processing message: {str(e)}")
                continue

        # Send email for each assignee
        for assignee, tasks in tasks_by_assignee.items():
            send_daily_reminder(assignee, tasks)

        return {
            "statusCode": 200,
            "body": json.dumps(
                {
                    "processed_assignees": len(tasks_by_assignee),
                    "total_tasks": sum(
                        len(tasks) for tasks in tasks_by_assignee.values()
                    ),
                }
            ),
        }

    except Exception as e:
        print(f"Error in task processor: {str(e)}")
        return {"statusCode": 500, "body": json.dumps({"error": str(e)})}


def send_daily_reminder(assignee, tasks):
    try:
        # Format email content
        subject = f"📋 Daily Task Reminder - {datetime.now().strftime('%A, %B %d')}"

        email_body = f"""
Hello!

Here are your pending tasks for today:

{format_task_list(tasks)}

Total Tasks: {len(tasks)}

You're doing great! Keep up the good work! 🚀

Best regards,
TaskFlow Reminders System
"""

        # Send via SNS
        sns.publish(
            TopicArn=os.environ["SNS_TOPIC_ARN"], Subject=subject, Message=email_body
        )

        print(f"Sent reminder email to {assignee} with {len(tasks)} tasks")

    except Exception as e:
        print(f"Error sending email to {assignee}: {str(e)}")


def format_task_list(tasks):
    task_lines = []
    for i, task in enumerate(tasks, 1):
        priority_icon = get_priority_icon(task.get("priority", "medium"))
        due_info = format_due_date(task.get("due_date"))

        task_line = f"{i}. {priority_icon} {task['title']}"
        if due_info:
            task_line += f" - {due_info}"
        if task.get("description"):
            task_line += f"\n   📝 {task['description']}"

        task_lines.append(task_line)

    return "\n".join(task_lines)


def get_priority_icon(priority):
    icons = {"high": "🔴", "medium": "🟡", "low": "🟢", "urgent": "🚨"}
    return icons.get(priority.lower(), "🟡")


def format_due_date(due_date):
    if not due_date:
        return ""

    try:
        due = datetime.fromisoformat(due_date.replace("Z", "+00:00"))
        today = datetime.utcnow().date()
        due_date_only = due.date()

        if due_date_only == today:
            return "Due Today"
        elif due_date_only == today + timedelta(days=1):
            return "Due Tomorrow"
        elif due_date_only < today:
            days_overdue = (today - due_date_only).days
            return f"Overdue by {days_overdue} days"
        else:
            days_until = (due_date_only - today).days
            return f"Due in {days_until} days"
    except:
        return f"Due: {due_date}"
