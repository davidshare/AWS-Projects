s3_buckets = {
  useearna-prod-infrastructure = {
    bucket = "useearna-prod-infrastructure"
    tags = {
      Name        = "useearna-prod-infrastructure"
      Environment = "prod"
      Owner = "Earna"
    }
    encryption_algorithm = "AES256"
    versioning_status = "Enabled"
    acl = "private"
    object_ownership = "BucketOwnerPreferred"
  }
}