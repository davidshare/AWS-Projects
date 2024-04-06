variable "project" {}
variable "createdby" {}
variable "environment" {}

locals {
  tags = {
    Project     = var.project
    createdby   = var.createdby
    CreatedOn   = timestamp()
    Environment = var.environment
  }
}