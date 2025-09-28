resource "aws_cloudwatch_event_rule" "daily_reminder" {
  name                = "${local.project_name}-daily-reminder"
  description         = "Trigger daily task reminders at 9 AM"
  schedule_expression = "cron(0 9 * * ? *)" # 9 AM daily

  tags = {
    Project = local.project_name
  }
}

resource "aws_cloudwatch_event_target" "trigger_task_processor" {
  rule = aws_cloudwatch_event_rule.daily_reminder.name
  arn  = aws_lambda_function.task_processor.arn
}

resource "aws_lambda_permission" "allow_cloudwatch" {
  statement_id  = "AllowExecutionFromCloudWatch"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.task_processor.function_name
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.daily_reminder.arn
}