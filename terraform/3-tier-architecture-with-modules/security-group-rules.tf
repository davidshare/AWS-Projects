variable "ingress_rules" {
  description = "List of ingress rules and their configurations"
  type = list(object({
    security_group_id            = string
    description                  = string
    from_port                    = number
    to_port                      = number
    protocol                     = string
    referenced_security_group_id = string
    cidr_ipv4                    = string
    cidr_ipv6                    = string
    prefix_list_ids              = string
    tags                         = map(string)
  }))
}

variable "egress_rules" {
  description = "List of ingress rules and their configurations"
  type = list(object({
    security_group_id            = string
    description                  = string
    from_port                    = number
    to_port                      = number
    protocol                     = string
    referenced_security_group_id = string
    cidr_ipv4                    = string
    cidr_ipv6                    = string
    prefix_list_ids              = string
    tags                         = map(string)
  }))
}

module "vpc_security_group_ingress_rule" {
  count = length(var.ingress_rules)

  source = "github.com/davidshare/terraform-aws-modules//vpc_security_group_ingress_rule?ref=vpc_security_group_ingress_rule-v1.0.0"

  security_group_id = module.security_group[var.ingress_rules[count.index].security_group_id].id
  from_port         = var.ingress_rules[count.index].from_port
  to_port           = var.ingress_rules[count.index].to_port
  ip_protocol       = var.ingress_rules[count.index].protocol
  description       = try(var.ingress_rules[count.index].description, null)
  tags              = merge(var.ingress_rules[count.index].tags, local.tags)

  cidr_ipv4                    = var.ingress_rules[count.index].cidr_ipv4
  cidr_ipv6                    = var.ingress_rules[count.index].cidr_ipv6
  prefix_list_id               = var.ingress_rules[count.index].prefix_list_ids
  referenced_security_group_id = var.ingress_rules[count.index].referenced_security_group_id != "" ? module.security_group[var.ingress_rules[count.index].referenced_security_group_id].id : ""

  depends_on = [module.security_group]
}

module "vpc_security_group_egress_rule" {
  count = length(var.egress_rules)

  source = "github.com/davidshare/terraform-aws-modules//vpc_security_group_egress_rule?ref=vpc_security_group_egress_rule-v1.0.0"

  security_group_id = module.security_group[var.egress_rules[count.index].security_group_id].id
  from_port         = var.egress_rules[count.index].from_port
  to_port           = var.egress_rules[count.index].to_port
  ip_protocol       = var.egress_rules[count.index].protocol
  description       = try(var.egress_rules[count.index].description, null)
  tags              = merge(var.egress_rules[count.index].tags, local.tags)

  cidr_ipv4                    = var.egress_rules[count.index].cidr_ipv4
  cidr_ipv6                    = var.egress_rules[count.index].cidr_ipv6
  prefix_list_id               = var.egress_rules[count.index].prefix_list_ids
  referenced_security_group_id = var.egress_rules[count.index].referenced_security_group_id != "" ? module.security_group[var.egress_rules[count.index].referenced_security_group_id].id : ""

  depends_on = [module.security_group]
}

