output "user_pool_id" {
  description = "Cognito User Pool ID"
  value       = aws_cognito_user_pool.blog_user_pool.id
}

output "app_client_id" {
  description = "Cognito App Client ID"
  value       = aws_cognito_user_pool_client.blog_app_client.id
}

output "api_endpoint" {
  description = "API Gateway endpoint URL"
  value       = aws_apigatewayv2_api.blog_api.api_endpoint
}

output "website_endpoint" {
  description = "S3 website endpoint"
  value       = aws_s3_bucket_website_configuration.blog_website.website_endpoint
}

output "s3_bucket_name" {
  description = "S3 bucket name for frontend"
  value       = aws_s3_bucket.blog_bucket.bucket
}

output "dynamodb_posts_table" {
  description = "DynamoDB posts table name"
  value       = aws_dynamodb_table.blog_posts.name
}

output "dynamodb_comments_table" {
  description = "DynamoDB comments table name"
  value       = aws_dynamodb_table.blog_comments.name
}