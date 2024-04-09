/* NAT */
variable "nat_gateways" {
  type = map(any)
}

resource "aws_nat_gateway" "nat_gateways" {
  for_each = var.nat_gateways

  allocation_id = aws_eip.nat_elastic_ips[each.value.elastic_ip].id
  subnet_id     = aws_subnet.subnets[each.value.subnet].id
  tags          = merge(each.value.tags, local.tags)

  depends_on = [aws_eip.nat_elastic_ips]
}