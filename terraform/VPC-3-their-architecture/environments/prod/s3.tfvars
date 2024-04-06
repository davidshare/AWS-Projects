s3_buckets = {
  tersu-prod-infrastructure = {
    bucket = "tersu-prod-infrastructure"
    encryption_algorithm = "AES256"
    versioning_status    = "Enabled"
    acl                  = "private"
    object_ownership     = "BucketOwnerPreferred"
    tags = {
      Name        = "terraform state"
      Description = "S3 bucket to store terraform state"
    }
  }
}