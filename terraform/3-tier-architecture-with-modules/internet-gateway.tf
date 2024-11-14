variable "internet_gateways" {
  description = "Map of internet gateways"
  type = map(object({
    vpc  = string
    tags = map(string)
  }))
}

module "internet_gateway" {
  for_each = var.internet_gateways
  source   = "../../../terraform-aws-modules/internet_gateway"

  vpc_id = module.vpc[each.value.vpc].vpc_id
  tags   = merge(each.value.tags, local.tags)
}