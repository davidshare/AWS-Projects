s3_buckets = {
  infrastructure_state = {
    bucket               = "infrastructure-state"
    encryption_algorithm = "AES256"
    versioning_status    = "Enabled"
    acl                  = "private"
    object_ownership     = "BucketOwnerPreferred"
    tags = {
      Name        = "infrastructure-state"
      Description = "S3 bucket to store terraform state"
    }
  }
}