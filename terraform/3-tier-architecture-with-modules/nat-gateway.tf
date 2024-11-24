variable "nat_gateways" {
  description = "Map of NAT Gateway configurations"
  type = map(object({
    vpc        = string
    elastic_ip = string
    subnet     = string
    tags       = map(string)
  }))
}

module "nat_gateway" {
  for_each = var.nat_gateways

  source = "../../../terraform-aws-modules/nat_gateway"

  allocation_id = module.elastic_ip[each.value.elastic_ip].allocation_id
  subnet_id     = module.subnets[each.value.subnet].id
  tags          = merge(each.value.tags, local.tags)

  depends_on = [module.elastic_ip]
}