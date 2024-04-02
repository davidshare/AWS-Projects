variable "dynamodb_tables" {}

resource "aws_dynamodb_table" "dynamodb_tables" {
  for_each = var.dynamodb_tables

  name           = each.value.name
  billing_mode   = each.value.billing_mode
  read_capacity  = each.value.read_capacity
  write_capacity = each.value.write_capacity
  hash_key       = each.value.hash_key

  attribute {
    name = each.value.hash_key
    type = each.value.hash_key_type
  }

  lifecycle {
    prevent_destroy = true
    ignore_changes = [ 
      billing_mode,
      read_capacity,
      write_capacity ]
  }
}