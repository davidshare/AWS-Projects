# Auth Lambda Function
data "archive_file" "auth_zip" {
  type        = "zip"
  source_file = "${local.backend_path}/auth/auth-handler.py"
  output_path = "${path.module}/lambda_zips/auth-handler.zip"
}

resource "aws_lambda_function" "auth_handler" {
  filename         = data.archive_file.auth_zip.output_path
  function_name    = "${var.project_name}-auth-handler"
  role             = aws_iam_role.lambda_role.arn
  handler          = "auth-handler.lambda_handler"
  runtime          = "python3.12"
  source_code_hash = data.archive_file.auth_zip.output_base64sha256
  timeout          = 30

  environment {
    variables = {
      COGNITO_USER_POOL_ID = aws_cognito_user_pool.blog_user_pool.id
    }
  }

  tags = {
    Name        = "${var.project_name}-auth-handler"
    Environment = "prod"
  }
}

# Posts Lambda Function
data "archive_file" "posts_zip" {
  type        = "zip"
  source_file = "${local.backend_path}/posts/posts-handler.py"
  output_path = "${path.module}/lambda_zips/posts-handler.zip"
}

resource "aws_lambda_function" "posts_handler" {
  filename         = data.archive_file.posts_zip.output_path
  function_name    = "${var.project_name}-posts-handler"
  role             = aws_iam_role.lambda_role.arn
  handler          = "posts-handler.lambda_handler"
  runtime          = "python3.12"
  source_code_hash = data.archive_file.posts_zip.output_base64sha256
  timeout          = 30

  environment {
    variables = {
      DYNAMODB_POSTS_TABLE = aws_dynamodb_table.blog_posts.name
      S3_BUCKET            = aws_s3_bucket.blog_bucket.bucket
      API_BASE_URL         = aws_apigatewayv2_api.blog_api.api_endpoint
    }
  }

  tags = {
    Name        = "${var.project_name}-posts-handler"
    Environment = "prod"
  }
}

# Comments Lambda Function
data "archive_file" "comments_zip" {
  type        = "zip"
  source_file = "${local.backend_path}/comments/comments-handler.py"
  output_path = "${path.module}/lambda_zips/comments-handler.zip"
}

resource "aws_lambda_function" "comments_handler" {
  filename         = data.archive_file.comments_zip.output_path
  function_name    = "${var.project_name}-comments-handler"
  role             = aws_iam_role.lambda_role.arn
  handler          = "comments-handler.lambda_handler"
  runtime          = "python3.12"
  source_code_hash = data.archive_file.comments_zip.output_base64sha256
  timeout          = 30

  environment {
    variables = {
      DYNAMODB_COMMENTS_TABLE = aws_dynamodb_table.blog_comments.name
    }
  }

  tags = {
    Name        = "${var.project_name}-comments-handler"
    Environment = "prod"
  }
}

# Lambda Permissions for API Gateway
resource "aws_lambda_permission" "api_gateway_auth" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.auth_handler.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_apigatewayv2_api.blog_api.execution_arn}/*/*"
}

resource "aws_lambda_permission" "api_gateway_posts" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.posts_handler.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_apigatewayv2_api.blog_api.execution_arn}/*/*"
}

resource "aws_lambda_permission" "api_gateway_comments" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.comments_handler.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_apigatewayv2_api.blog_api.execution_arn}/*/*"
}