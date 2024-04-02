s3_buckets = {
  tersu-stage-infrastructure = {
    bucket = "tersu-stage-infrastructure"
    tags = {
      Name        = "tersu-stage-infrastructure"
      Environment = "stage"
      Owner = "Tersu"
    }
    encryption_algorithm = "AES256"
    versioning_status = "Enabled"
    acl = "private"
    object_ownership = "BucketOwnerPreferred"
  }
}