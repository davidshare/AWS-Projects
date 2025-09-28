output "api_gateway_url" {
  description = "URL for the Task API Gateway"
  value       = aws_api_gateway_stage.prod.invoke_url
}

output "sns_topic_arn" {
  description = "ARN of the SNS topic for email notifications"
  value       = aws_sns_topic.task_reminders.arn
}

output "sqs_queue_url" {
  description = "URL of the SQS queue for task processing"
  value       = aws_sqs_queue.task_queue.url
}