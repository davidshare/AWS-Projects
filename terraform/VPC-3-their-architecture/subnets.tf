variable "aws_subnets" {}

resource "aws_subnet" "subnets" {
  for_each = var.aws_subnets

  vpc_id                  = aws_vpc.vpcs[each.value.vpc].id
  cidr_block              = each.value.cidr_block
  availability_zone       = each.value.availability_zone
  map_public_ip_on_launch = each.value.map_public_ip_on_launch
  tags                    = merge(each.value.tags, local.tags)

  depends_on = [aws_vpc.vpcs]
}
