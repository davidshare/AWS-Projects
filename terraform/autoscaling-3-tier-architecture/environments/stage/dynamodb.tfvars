dynamodb_tables = {
  "infrastructure_state_lock" = {
    name           = "terraform-state-lock"
    billing_mode   = "PROVISIONED"
    read_capacity  = 5
    write_capacity = 5
    hash_key       = "LockID"
    hash_key_type  = "S"

    tags = {
      Name        = "infrastructure-state-lock"
      Description = "Table for locking terraform state"
    }
  }
}