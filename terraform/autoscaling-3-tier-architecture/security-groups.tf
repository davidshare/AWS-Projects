variable "security_groups" {}
variable "security_group_rules" {}

locals {
  vpc_id = {
    tersu = data.aws_vpc.tersu
  }
}

resource "aws_security_group" "security_groups" {
  for_each = var.security_groups

  name        = each.value.name
  description = each.value.description
  vpc_id      = local.vpc_id[each.value.vpc].id

  tags = merge(local.tags, each.value.tags)

  lifecycle {
    ignore_changes = [tags]
  }
}

resource "aws_security_group_rule" "security_group_rules" {
  count = length(var.security_group_rules)

  security_group_id        = aws_security_group.security_groups[element(var.security_group_rules, count.index).security_group].id
  type                     = element(var.security_group_rules, count.index).type
  description              = element(var.security_group_rules, count.index).description
  from_port                = element(var.security_group_rules, count.index).from_port
  to_port                  = element(var.security_group_rules, count.index).to_port
  protocol                 = element(var.security_group_rules, count.index).protocol
  cidr_blocks              = try(element(var.security_group_rules, count.index).cidr_blocks, null)
  source_security_group_id = try(aws_security_group.security_groups[element(var.security_group_rules, count.index).source_security_group].id, null)
}

