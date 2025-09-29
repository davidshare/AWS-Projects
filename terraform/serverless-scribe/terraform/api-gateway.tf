# Main HTTP API
resource "aws_apigatewayv2_api" "blog_api" {
  name          = "${var.project_name}-api"
  protocol_type = "HTTP"
  description   = "Serverless Blog API"

  cors_configuration {
    allow_origins = ["*"]
    allow_methods = ["GET", "POST", "PUT", "DELETE", "OPTIONS"]
    allow_headers = ["*"]
    max_age       = 300
  }

  tags = {
    Name        = "${var.project_name}-api"
    Environment = "prod"
  }
}

# Cognito Authorizer
resource "aws_apigatewayv2_authorizer" "cognito_authorizer" {
  api_id           = aws_apigatewayv2_api.blog_api.id
  authorizer_type  = "JWT"
  identity_sources = ["$request.header.Authorization"]
  name             = "${var.project_name}-cognito-authorizer"

  jwt_configuration {
    audience = [aws_cognito_user_pool_client.blog_app_client.id]
    issuer   = "https://cognito-idp.${var.region}.amazonaws.com/${aws_cognito_user_pool.blog_user_pool.id}"
  }
}

# Lambda Integrations
resource "aws_apigatewayv2_integration" "auth_integration" {
  api_id             = aws_apigatewayv2_api.blog_api.id
  integration_type   = "AWS_PROXY"
  integration_uri    = aws_lambda_function.auth_handler.invoke_arn
  integration_method = "POST"
}

resource "aws_apigatewayv2_integration" "posts_integration" {
  api_id             = aws_apigatewayv2_api.blog_api.id
  integration_type   = "AWS_PROXY"
  integration_uri    = aws_lambda_function.posts_handler.invoke_arn
  integration_method = "POST"
}

resource "aws_apigatewayv2_integration" "comments_integration" {
  api_id             = aws_apigatewayv2_api.blog_api.id
  integration_type   = "AWS_PROXY"
  integration_uri    = aws_lambda_function.comments_handler.invoke_arn
  integration_method = "POST"
}

# Auth Routes
resource "aws_apigatewayv2_route" "auth_login" {
  api_id    = aws_apigatewayv2_api.blog_api.id
  route_key = "POST /auth/login"
  target    = "integrations/${aws_apigatewayv2_integration.auth_integration.id}"
}

resource "aws_apigatewayv2_route" "users_create" {
  api_id             = aws_apigatewayv2_api.blog_api.id
  route_key          = "POST /users"
  target             = "integrations/${aws_apigatewayv2_integration.auth_integration.id}"
  authorization_type = "JWT"
  authorizer_id      = aws_apigatewayv2_authorizer.cognito_authorizer.id
}

# Posts Routes
resource "aws_apigatewayv2_route" "posts_create" {
  api_id             = aws_apigatewayv2_api.blog_api.id
  route_key          = "POST /posts"
  target             = "integrations/${aws_apigatewayv2_integration.posts_integration.id}"
  authorization_type = "JWT"
  authorizer_id      = aws_apigatewayv2_authorizer.cognito_authorizer.id
}

resource "aws_apigatewayv2_route" "posts_list" {
  api_id    = aws_apigatewayv2_api.blog_api.id
  route_key = "GET /posts"
  target    = "integrations/${aws_apigatewayv2_integration.posts_integration.id}"
}

resource "aws_apigatewayv2_route" "posts_get" {
  api_id    = aws_apigatewayv2_api.blog_api.id
  route_key = "GET /posts/{post_id}"
  target    = "integrations/${aws_apigatewayv2_integration.posts_integration.id}"
}

resource "aws_apigatewayv2_route" "posts_update" {
  api_id             = aws_apigatewayv2_api.blog_api.id
  route_key          = "PUT /posts/{post_id}"
  target             = "integrations/${aws_apigatewayv2_integration.posts_integration.id}"
  authorization_type = "JWT"
  authorizer_id      = aws_apigatewayv2_authorizer.cognito_authorizer.id
}

resource "aws_apigatewayv2_route" "posts_delete" {
  api_id             = aws_apigatewayv2_api.blog_api.id
  route_key          = "DELETE /posts/{post_id}"
  target             = "integrations/${aws_apigatewayv2_integration.posts_integration.id}"
  authorization_type = "JWT"
  authorizer_id      = aws_apigatewayv2_authorizer.cognito_authorizer.id
}

# Comments Routes
resource "aws_apigatewayv2_route" "comments_create" {
  api_id    = aws_apigatewayv2_api.blog_api.id
  route_key = "POST /comments"
  target    = "integrations/${aws_apigatewayv2_integration.comments_integration.id}"
}

resource "aws_apigatewayv2_route" "comments_get" {
  api_id    = aws_apigatewayv2_api.blog_api.id
  route_key = "GET /comments/{post_id}"
  target    = "integrations/${aws_apigatewayv2_integration.comments_integration.id}"
}

# Default Route (for handling undefined routes)
resource "aws_apigatewayv2_route" "default" {
  api_id    = aws_apigatewayv2_api.blog_api.id
  route_key = "$default"
  target    = "integrations/${aws_apigatewayv2_integration.posts_integration.id}"
}

# API Stage
resource "aws_apigatewayv2_stage" "prod" {
  api_id      = aws_apigatewayv2_api.blog_api.id
  name        = "prod"
  auto_deploy = true

  tags = {
    Name        = "${var.project_name}-api-stage"
    Environment = "prod"
  }
}

# OPTIONS routes for CORS preflight
resource "aws_apigatewayv2_route" "options_auth" {
  api_id    = aws_apigatewayv2_api.blog_api.id
  route_key = "OPTIONS /auth/{proxy+}"
  target    = "integrations/${aws_apigatewayv2_integration.auth_integration.id}"
}

resource "aws_apigatewayv2_route" "options_posts" {
  api_id    = aws_apigatewayv2_api.blog_api.id
  route_key = "OPTIONS /posts/{proxy+}"
  target    = "integrations/${aws_apigatewayv2_integration.posts_integration.id}"
}

resource "aws_apigatewayv2_route" "options_comments" {
  api_id    = aws_apigatewayv2_api.blog_api.id
  route_key = "OPTIONS /comments/{proxy+}"
  target    = "integrations/${aws_apigatewayv2_integration.comments_integration.id}"
}

resource "aws_apigatewayv2_route" "options_users" {
  api_id    = aws_apigatewayv2_api.blog_api.id
  route_key = "OPTIONS /users"
  target    = "integrations/${aws_apigatewayv2_integration.auth_integration.id}"
}