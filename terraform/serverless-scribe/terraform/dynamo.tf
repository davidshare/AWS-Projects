resource "aws_dynamodb_table" "blog_posts" {
  name         = "${var.project_name}-posts"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "post_id"

  attribute {
    name = "post_id"
    type = "S"
  }

  tags = {
    Name        = "${var.project_name}-posts"
    Environment = "prod"
  }
}

resource "aws_dynamodb_table" "blog_comments" {
  name         = "${var.project_name}-comments"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "post_id"
  range_key    = "comment_id"

  attribute {
    name = "post_id"
    type = "S"
  }

  attribute {
    name = "comment_id"
    type = "S"
  }

  tags = {
    Name        = "${var.project_name}-comments"
    Environment = "prod"
  }
}