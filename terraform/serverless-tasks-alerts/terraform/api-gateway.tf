resource "aws_api_gateway_rest_api" "task_api" {
  name        = "${local.project_name}-api"
  description = "API for adding tasks to reminder system"

  endpoint_configuration {
    types = ["REGIONAL"]
  }

  tags = {
    Project = local.project_name
  }
}

resource "aws_api_gateway_resource" "tasks" {
  rest_api_id = aws_api_gateway_rest_api.task_api.id
  parent_id   = aws_api_gateway_rest_api.task_api.root_resource_id
  path_part   = "tasks"
}

resource "aws_api_gateway_method" "post_tasks" {
  rest_api_id   = aws_api_gateway_rest_api.task_api.id
  resource_id   = aws_api_gateway_resource.tasks.id
  http_method   = "POST"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "tasks_integration" {
  rest_api_id             = aws_api_gateway_rest_api.task_api.id
  resource_id             = aws_api_gateway_resource.tasks.id
  http_method             = aws_api_gateway_method.post_tasks.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.api_handler.invoke_arn
}

# Create the stage separately
resource "aws_api_gateway_stage" "prod" {
  deployment_id = aws_api_gateway_deployment.task_api_deployment.id
  rest_api_id   = aws_api_gateway_rest_api.task_api.id
  stage_name    = "prod"
}

resource "aws_api_gateway_deployment" "task_api_deployment" {
  depends_on = [aws_api_gateway_integration.tasks_integration]

  rest_api_id = aws_api_gateway_rest_api.task_api.id

  triggers = {
    redeployment = sha1(jsonencode([
      aws_api_gateway_resource.tasks.id,
      aws_api_gateway_method.post_tasks.id,
      aws_api_gateway_integration.tasks_integration.id
    ]))
  }

  lifecycle {
    create_before_destroy = true
  }
}