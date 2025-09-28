# API Handler Lambda
data "archive_file" "api_handler_zip" {
  type        = "zip"
  source_file = "${path.module}/../api/api-handler.py"
  output_path = "${path.module}/lambda_zips/api-handler.zip"
}

resource "aws_lambda_function" "api_handler" {
  filename         = data.archive_file.api_handler_zip.output_path
  function_name    = "${local.project_name}-api-handler"
  role             = aws_iam_role.lambda_role.arn
  handler          = "api-handler.lambda_handler"
  runtime          = "python3.12"
  source_code_hash = data.archive_file.api_handler_zip.output_base64sha256
  timeout          = 30

  environment {
    variables = {
      SQS_QUEUE_URL = aws_sqs_queue.task_queue.url
    }
  }

  tags = {
    Project = local.project_name
  }
}

# Task Processor Lambda
data "archive_file" "task_processor_zip" {
  type        = "zip"
  source_file = "${path.module}/../api/task-processor.py"
  output_path = "${path.module}/lambda_zips/task-processor.zip"
}

resource "aws_lambda_function" "task_processor" {
  filename         = data.archive_file.task_processor_zip.output_path
  function_name    = "${local.project_name}-task-processor"
  role             = aws_iam_role.lambda_role.arn
  handler          = "task-processor.lambda_handler"
  runtime          = "python3.12"
  source_code_hash = data.archive_file.task_processor_zip.output_base64sha256
  timeout          = 60

  environment {
    variables = {
      SNS_TOPIC_ARN = aws_sns_topic.task_reminders.arn
    }
  }

  tags = {
    Project = local.project_name
  }
}

# Lambda Permissions
resource "aws_lambda_permission" "api_gateway" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.api_handler.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_api_gateway_rest_api.task_api.execution_arn}/*/*"
}

resource "aws_lambda_event_source_mapping" "sqs_trigger" {
  event_source_arn = aws_sqs_queue.task_queue.arn
  function_name    = aws_lambda_function.task_processor.arn
  batch_size       = 10
}