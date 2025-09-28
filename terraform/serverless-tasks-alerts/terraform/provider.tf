# terraform {
#   required_version = ">= 1.13.3"
#   required_providers {
#     aws = {
#       source  = "hashicorp/aws"
#       version = "~> 6.14.1"
#     }
#     archive = {
#       source  = "hashicorp/archive"
#       version = "~> 2.4.0"
#     }
#   }
# }

# provider "aws" {
#   region  = local.region
#   profile = "cyber1admin"
# }

terraform {
  required_version = ">= 1.13.3"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.14.1"
    }
  }
}

# Configure the AWS Provider
provider "aws" {
  profile = "localstack"
  region  = "us-east-1"

  # LocalStack specific settings
  skip_credentials_validation = true
  skip_metadata_api_check     = true
  skip_requesting_account_id  = true

  endpoints {
    apigateway              = "http://localhost:4566"
    cloudwatch              = "http://localhost:4566"
    cognitoidentityprovider = "http://localhost:4566"
    dynamodb                = "http://localhost:4566"
    iam                     = "http://localhost:4566"
    lambda                  = "http://localhost:4566"
    s3                      = "http://localhost:4566"
  }
}