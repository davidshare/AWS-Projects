s3_buckets = {
  usetersu-stage-infrastructure = {
    bucket = "usetersu-stage-infrastructure"
    tags = {
      Name        = "usetersu-stage-infrastructure"
      Environment = "stage"
      Owner = "Tersu"
    }
    encryption_algorithm = "AES256"
    versioning_status = "Enabled"
    acl = "private"
    object_ownership = "BucketOwnerPreferred"
  }
}