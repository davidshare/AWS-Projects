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

  source = "github.com/davidshare/terraform-aws-modules//network_acl?ref=network_acl-v1.0.0"

  vpc_id     = module.vpc[each.value.vpc].id
  subnet_ids = flatten([for subnet in each.value.subnets : module.subnets[subnet].id])
  tags       = merge(each.value.tags, local.tags)
}