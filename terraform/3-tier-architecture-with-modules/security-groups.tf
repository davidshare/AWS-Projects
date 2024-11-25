variable "security_groups" {
  description = "Map of Security Groups with their configuration"
  type = map(object({
    name                   = string
    description            = string
    vpc_name               = string
    revoke_rules_on_delete = bool
    tags                   = map(string)
  }))
}

module "security_group" {
  for_each = var.security_groups

  source = "github.com/davidshare/terraform-aws-modules//security_group?ref=security_group-v1.0.0"

  name                   = each.value.name
  description            = each.value.description
  vpc_id                 = module.vpc[each.value.vpc_name].id
  revoke_rules_on_delete = each.value.revoke_rules_on_delete
  tags                   = merge(each.value.tags, local.tags)
}
