variable "region" {
  description = "AWS region"
  default     = "us-east-1"
  type        = string
}

variable "bucket_name" {
  description = "S3 bucket name for the blog"
  type        = string
}

variable "project_name" {
  description = "Project name for resource naming"
  default     = "serverless-scribe"
  type        = string
}