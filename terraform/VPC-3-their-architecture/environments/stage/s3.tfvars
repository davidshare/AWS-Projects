s3_buckets = {
  useearna-stage-infrastructure = {
    bucket = "useearna-stage-infrastructure"
    tags = {
      Name        = "useearna-stage-infrastructure"
      Environment = "stage"
      Owner = "Earna"
    }
    encryption_algorithm = "AES256"
    versioning_status = "Enabled"
    acl = "private"
    object_ownership = "BucketOwnerPreferred"
  }
}