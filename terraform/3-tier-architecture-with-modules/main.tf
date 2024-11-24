variable "project" {}
variable "createdBy" {}
variable "environment" {}
variable "owner" {}

locals {
  tags = {
    Project     = var.project
    createdby   = var.createdBy
    Environment = var.environment
    Owner       = var.owner
  }
}