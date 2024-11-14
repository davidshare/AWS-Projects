variable "route_tables" {}
variable "subnets_route_table_association" {}
variable "internet_gateway_routes" {}
variable "nat_gateway_routes" {}

# Route tables
module "route_table" {
  for_each = var.route_tables

  source = "../../../terraform-aws-modules/route_table"

  vpc_id = module.vpc[each.value.vpc].vpc_id
  tags   = merge(each.value.tags, local.tags)
}

# Route table associations
module "subnets_route_table_associations" {
  for_each = var.subnets_route_table_association

  source = "../../../terraform-aws-modules/route_table_association"

  subnet_id      = module.subnet[each.value.subnet].subnet_id
  route_table_id = module.route_table[each.value.route_table].route_table_id

  depends_on = [ module.subnet, module.var.route_table ]
}

# Routes for Internet Gateway
module "internet_gateway_routes" {
  for_each = var.internet_gateway_routes

  source = "../../../terraform-aws-modules/route"

  route_table_id         = module.route_table[each.value.route_table].route_table_id
  destination_cidr_block = each.value.cidr
  gateway_id             = module.internet_gateway[each.value.gateway].internet_gateway_id

  depends_on = [ module.internet_gateway, module.route_table ]
}

# Routes for NAT
module "nat_gateway_routes" {
  for_each = var.nat_gateway_routes

  source = "../../../terraform-aws-modules/route"

  route_table_id         = module.route_table[each.value.route_table].route_table_id
  destination_cidr_block = each.value.cidr
  nat_gateway_id         = module.nat_gateway[each.value.gateway].nat_gateway_id

  depends_on = [ module.nat_gateway, module.route_table ]
}