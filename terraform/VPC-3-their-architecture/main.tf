variable "project" {}
variable "createdBy" {}
variable "environment" {}
variable "owner" {}

locals {
  tags = {
    Project     = var.project
    createdby   = var.createdBy
    CreatedOn   = timestamp()
    Environment = var.environment
    Owner       = var.owner
  }
}