terraform {
  required_version = ">= 1.7.5"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.43.0"
    }
  }

  backend "s3" {}
}

# Configure the AWS Provider
provider "aws" {
  region  = "us-east-1"
  profile = "cyberdavid1"
}

