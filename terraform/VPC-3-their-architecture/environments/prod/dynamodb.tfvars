dynamodb_tables = {
  "terraform_lock" = {
    name           = "terraform-prod-statelock"
    billing_mode   = "PROVISIONED"
    read_capacity  = 5
    write_capacity = 5
    hash_key       = "LockID"
    hash_key_type  = "S"
  }
}