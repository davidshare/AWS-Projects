resource "aws_dynamodb_table" "blog_posts" {
  name         = "${var.project_name}-posts"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "post_id"
  

  attribute {
    name = "post_id"
    type = "S"
  }

  attribute {
    name = "publish_date"
    type = "S"
  }

  attribute {
    name = "status"
    type = "S"
  }

  global_secondary_index {
    name               = "publish_date_index"
    hash_key           = "status"
    range_key          = "publish_date"
    projection_type    = "ALL"
    read_capacity      = 5
    write_capacity     = 5
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