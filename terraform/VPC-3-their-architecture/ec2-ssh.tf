variable "ssh_keys" {}

resource "aws_key_pair" "ssh_keys" {
  for_each = var.ssh_keys

  key_name   = each.value.key_name
  public_key = each.value.public_key
}