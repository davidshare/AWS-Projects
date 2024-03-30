s3_buckets = {
  usetersu-prod-infrastructure = {
    bucket = "usetersu-prod-infrastructure"
    tags = {
      Name        = "usetersu-prod-infrastructure"
      Environment = "prod"
      Owner = "Tersu"
    }
    encryption_algorithm = "AES256"
    versioning_status = "Enabled"
    acl = "private"
    object_ownership = "BucketOwnerPreferred"
  }
}