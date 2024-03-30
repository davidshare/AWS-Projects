terraform {
  required_version = ">= 1.7.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.33.0"
    }
  }

  backend "s3" {}
}

# Configure the AWS Provider
provider "aws" {
  region = "eu-north-1"
  profile= "earna"
}

