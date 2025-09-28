resource "aws_sns_topic" "task_reminders" {
  name = "${local.project_name}-topic"

  tags = {
    Project = local.project_name
  }
}

resource "aws_sns_topic_subscription" "team_emails" {
  for_each = toset(var.team_emails)

  topic_arn = aws_sns_topic.task_reminders.arn
  protocol  = "email"
  endpoint  = each.value
}