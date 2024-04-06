variable "s3_buckets" {}

resource "aws_s3_bucket" "s3_buckets" {
  for_each = var.s3_buckets

  bucket = each.key
  tags   = each.value.tags

  lifecycle {
    prevent_destroy = true
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "bucket_server_side_encryption" {
  for_each = var.s3_buckets

  bucket = aws_s3_bucket.s3_buckets[each.key].id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = each.value.encryption_algorithm
    }
  }

  depends_on = [
    aws_s3_bucket.s3_buckets
  ]
}

resource "aws_s3_bucket_acl" "s3_bucket_acls" {
  for_each = var.s3_buckets

  bucket = aws_s3_bucket.s3_buckets[each.key].id
  acl    = each.value.acl

  depends_on = [
    aws_s3_bucket.s3_buckets,
    aws_s3_bucket_ownership_controls.bucket_ownership_controls
  ]
}

resource "aws_s3_bucket_ownership_controls" "bucket_ownership_controls" {
  for_each = var.s3_buckets

  bucket = aws_s3_bucket.s3_buckets[each.key].id
  rule {
    object_ownership = "BucketOwnerPreferred"
  }

  depends_on = [
    aws_s3_bucket.s3_buckets
  ]
}

resource "aws_s3_bucket_versioning" "s3_bucket_versionings" {
  for_each = var.s3_buckets

  bucket = aws_s3_bucket.s3_buckets[each.key].id
  versioning_configuration {
    status = each.value.versioning_status
  }

  depends_on = [
    aws_s3_bucket.s3_buckets
  ]
}
