resource "aws_cognito_user_pool" "blog_user_pool" {
  name = "${var.project_name}-user-pool"

  password_policy {
    minimum_length    = 8
    require_lowercase = true
    require_numbers   = true
    require_symbols   = true
    require_uppercase = true
  }

  auto_verified_attributes = ["email"]
  mfa_configuration        = "OFF" # Change to ON for production

  schema {
    name                = "email"
    attribute_data_type = "String"
    required            = true
    mutable             = true

    string_attribute_constraints {
      min_length = 1
      max_length = 2048
    }
  }

  tags = {
    Name        = "${var.project_name}-user-pool"
    Environment = "prod"
  }
}

resource "aws_cognito_user_pool_client" "blog_app_client" {
  name         = "${var.project_name}-app-client"
  user_pool_id = aws_cognito_user_pool.blog_user_pool.id

  generate_secret              = false
  explicit_auth_flows          = ["ALLOW_USER_PASSWORD_AUTH", "ALLOW_REFRESH_TOKEN_AUTH"]
  supported_identity_providers = ["COGNITO"]

  callback_urls = ["http://localhost:3000"] # For testing
  logout_urls   = ["http://localhost:3000"] # For testing
}

resource "aws_cognito_user_group" "admins" {
  name         = "Admins"
  user_pool_id = aws_cognito_user_pool.blog_user_pool.id
  description  = "Administrators with full access"
}

# Create an initial admin user (you'll need to set password manually)
resource "aws_cognito_user" "admin_user" {
  user_pool_id = aws_cognito_user_pool.blog_user_pool.id
  username     = "admin"
  attributes = {
    email = "devopsforge@gmail.com"
  }
}

resource "aws_cognito_user_in_group" "admin_group" {
  user_pool_id = aws_cognito_user_pool.blog_user_pool.id
  username     = aws_cognito_user.admin_user.username
  group_name   = aws_cognito_user_group.admins.name
}