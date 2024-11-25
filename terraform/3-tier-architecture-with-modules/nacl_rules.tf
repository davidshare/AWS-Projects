variable "network_acl_rules" {
  description = "Map of NACL configurations"
  type = map(object({
    network_acl = string
    rule_number = number
    protocol    = string
    rule_action = string
    cidr_block  = string
    from_port   = optional(number)
    to_port     = optional(number)
    egress      = bool
  }))
}

module "network_acl_rules" {
  for_each = var.network_acl_rules

  source = "github.com/davidshare/terraform-aws-modules//network_acl_rule?ref=network_acl_rule-v1.0.0"

  network_acl_id = module.network_acl[each.value.network_acl].network_acl_id
  rule_number    = each.value.rule_number
  rule_action    = each.value.rule_action
  cidr_block     = each.value.cidr_block
  protocol       = each.value.protocol
  from_port      = each.value.from_port
  to_port        = each.value.to_port
  egress         = each.value.egress
}