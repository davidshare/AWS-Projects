variable "elastic_ips" {
  type = map(any)
}

/* Elastic IP for NAT */
resource "aws_eip" "elastic_ips" {
  for_each = var.elastic_ips

  domain        = each.value.domain
  depends_on = [aws_internet_gateway.internet_gateways["main"]]
  tags = each.value.tags
}