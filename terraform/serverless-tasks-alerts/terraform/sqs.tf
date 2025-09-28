resource "aws_sqs_queue" "task_queue" {
  name                      = "${local.project_name}-queue"
  delay_seconds             = 0
  max_message_size          = 2048
  message_retention_seconds = 86400 # 1 day
  receive_wait_time_seconds = 10

  tags = {
    Project = local.project_name
  }
}

resource "aws_sqs_queue" "dead_letter_queue" {
  name = "${local.project_name}-dlq"
}

resource "aws_sqs_queue_redrive_allow_policy" "task_queue_redrive" {
  queue_url = aws_sqs_queue.task_queue.id

  redrive_allow_policy = jsonencode({
    redrivePermission = "byQueue",
    sourceQueueArns   = [aws_sqs_queue.dead_letter_queue.arn]
  })
}

resource "aws_sqs_queue_redrive_policy" "task_queue_policy" {
  queue_url = aws_sqs_queue.task_queue.id

  redrive_policy = jsonencode({
    deadLetterTargetArn = aws_sqs_queue.dead_letter_queue.arn
    maxReceiveCount     = 3
  })
}