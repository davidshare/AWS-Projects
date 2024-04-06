variable "route_tables" {}
variable "subnets_route_table_association" {}
variable "internet_gateway_routes" {}
variable "nat_gateway_routes" {}

# Route tables
resource "aws_route_table" "route_tables" {
  for_each = var.route_tables

  vpc_id = aws_vpc.vpcs[each.value.vpc].id
  tags   = merge(each.value.tags, local.tags)
}

# Route table associations
resource "aws_route_table_association" "subnets_route_table_associations" {
  for_each = var.subnets_route_table_association

  subnet_id      = aws_subnet.subnets[each.value.subnet].id
  route_table_id = aws_route_table.route_tables[each.value.route_table].id
}


# Routes for Internet Gateway
resource "aws_route" "internet_gateway_routes" {
  for_each = var.internet_gateway_routes

  route_table_id         = aws_route_table.route_tables[each.value.route_table].id
  destination_cidr_block = each.value.cidr
  gateway_id             = aws_internet_gateway.internet_gateways[each.value.gateway].id
}

# Routes for NAT
resource "aws_route" "nat_gateway_routes" {
  for_each = var.nat_gateway_routes

  route_table_id         = aws_route_table.route_tables[each.value.route_table].id
  destination_cidr_block = each.value.cidr
  nat_gateway_id         = aws_nat_gateway.nat_gateways[each.key].id
}