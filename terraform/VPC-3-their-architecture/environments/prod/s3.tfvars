s3_buckets = {
  tersu-prod-infrastructure = {
    bucket = "tersu-prod-infrastructure"
    tags = {
      Name        = "tersu-prod-infrastructure"
      Environment = "prod"
      Owner       = "Tersu"
    }
    encryption_algorithm = "AES256"
    versioning_status    = "Enabled"
    acl                  = "private"
    object_ownership     = "BucketOwnerPreferred"
  }
}