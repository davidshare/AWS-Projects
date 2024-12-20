variable "db_subnet_groups" {
  description = "Map of DB Subnet Group configurations"
  type = map(object({
    name        = string
    description = string
    subnets     = list(string)
    tags        = map(string)
  }))
}

module "db_subnet_groups" {
  for_each = var.db_subnet_groups

  source = "github.com/davidshare/terraform-aws-modules//db_subnet_group?ref=db_subnet_group-v1.0.0"

  name        = each.value.name
  description = each.value.description
  subnet_ids  = [for subnet in each.value.subnets : module.subnets[subnet].id]
  tags        = merge(each.value.tags, local.tags)
}
