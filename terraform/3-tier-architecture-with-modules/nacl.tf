variable "network_acls" {
  description = "Map of NACL configurations"
  type = map(object({
    vpc     = string
    subnets = list(string)
    tags    = map(string)
  }))
}

module "network_acl" {
  for_each = var.network_acls

  source = "../../../terraform-aws-modules/network_acl"

  vpc_id     = module.vpc[each.value.vpc].vpc_id
  subnet_ids = flatten([for subnet in each.value.subnets : module.subnet[subnet].subnet_id])
  tags       = merge(each.value.tags, local.tags)
}