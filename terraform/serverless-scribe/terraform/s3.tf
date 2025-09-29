resource "aws_s3_bucket" "blog_bucket" {
  bucket = "${var.project_name}-${data.aws_caller_identity.current.account_id}"
  tags = {
    Name        = "${var.project_name}-bucket"
    Environment = "prod"
  }
}

resource "aws_s3_bucket_website_configuration" "blog_website" {
  bucket = aws_s3_bucket.blog_bucket.id

  index_document {
    suffix = "index.html"
  }

  error_document {
    key = "error.html" # Create a simple error.html if needed
  }
}

resource "aws_s3_bucket_public_access_block" "blog_bucket_access" {
  bucket = aws_s3_bucket.blog_bucket.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

resource "aws_s3_bucket_policy" "blog_bucket_policy" {
  bucket     = aws_s3_bucket.blog_bucket.id
  depends_on = [aws_s3_bucket_public_access_block.blog_bucket_access]

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid       = "PublicReadGetObject"
        Effect    = "Allow"
        Principal = "*"
        Action    = "s3:GetObject"
        Resource  = "${aws_s3_bucket.blog_bucket.arn}/*"
      }
    ]
  })
}


# Upload basic frontend files
resource "aws_s3_object" "index_html" {
  bucket       = aws_s3_bucket.blog_bucket.id
  key          = "index.html"
  source       = "${local.frontend_path}/index.html"
  content_type = "text/html"
  etag         = filemd5("${local.frontend_path}/index.html")
}

resource "aws_s3_object" "error_html" {
  bucket       = aws_s3_bucket.blog_bucket.id
  key          = "error.html"
  content      = "<html><body><h1>Error</h1><p>Page not found</p></body></html>"
  content_type = "text/html"
}

resource "aws_s3_object" "css_styles" {
  bucket       = aws_s3_bucket.blog_bucket.id
  key          = "css/styles.css"
  source       = "${local.frontend_path}/css/styles.css"
  content_type = "text/css"
  etag         = filemd5("${local.frontend_path}/css/styles.css")
}

resource "aws_s3_object" "admin_html" {
  bucket       = aws_s3_bucket.blog_bucket.id
  key          = "admin.html"
  source       = "${local.frontend_path}/admin.html"
  content_type = "text/html"
  etag         = filemd5("${local.frontend_path}/admin.html")
}

resource "aws_s3_object" "comments_js" {
  bucket       = aws_s3_bucket.blog_bucket.id
  key          = "js/comments.js"
  source       = "${local.frontend_path}/js/comments.js"
  content_type = "application/javascript"
  etag         = filemd5("${local.frontend_path}/js/comments.js")
}

resource "aws_s3_object" "utils_js" {
  bucket       = aws_s3_bucket.blog_bucket.id
  key          = "js/utils.js"
  source       = "${local.frontend_path}/js/utils.js"
  content_type = "application/javascript"
  etag         = filemd5("${local.frontend_path}/js/utils.js")
}

resource "aws_s3_object" "auth_js" {
  bucket       = aws_s3_bucket.blog_bucket.id
  key          = "js/auth.js"
  source       = "${local.frontend_path}/js/auth.js"
  content_type = "application/javascript"
  etag         = filemd5("${local.frontend_path}/js/auth.js")
}

resource "aws_s3_object" "posts_js" {
  bucket       = aws_s3_bucket.blog_bucket.id
  key          = "js/posts.js"
  source       = "${local.frontend_path}/js/posts.js"
  content_type = "application/javascript"
  etag         = filemd5("${local.frontend_path}/js/posts.js")
}

resource "aws_s3_object" "admin_js" {
  bucket       = aws_s3_bucket.blog_bucket.id
  key          = "js/admin.js"
  source       = "${local.frontend_path}/js/admin.js"
  content_type = "application/javascript"
  etag         = filemd5("${local.frontend_path}/js/admin.js")
}

# generate config.js file
resource "aws_s3_object" "config_js" {
  bucket       = aws_s3_bucket.blog_bucket.id
  key          = "js/config.js"
  content_type = "application/javascript"
  content = templatefile("${local.frontend_path}/config.js.tpl", {
    api_endpoint  = aws_apigatewayv2_api.blog_api.api_endpoint
    app_client_id = aws_cognito_user_pool_client.blog_app_client.id
    bucket_name   = aws_s3_bucket.blog_bucket.bucket
  })
}

# Create posts directory (empty folder marker)
resource "aws_s3_object" "posts_folder" {
  bucket = aws_s3_bucket.blog_bucket.id
  key    = "posts/"
  source = "/dev/null" # Empty file to create folder
}

