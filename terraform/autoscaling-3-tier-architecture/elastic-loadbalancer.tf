variable "albs" {}
variable "lb_target_groups" {}
variable "alb_listeners" {}

resource "aws_lb" "albs" {
  for_each = var.albs

  name                       = each.value.name
  internal                   = each.value.internal
  load_balancer_type         = each.value.load_balancer_type
  security_groups            = [for sg in each.value.security_groups : aws_security_group.alb_security_group[sg].id]
  subnets                    = [for subnet in each.value.subnets : local.subnet_ids_map[subnet]]
  enable_deletion_protection = each.value.enable_deletion_protection

  tags = merge(each.value.tags, local.tags)

  lifecycle {
    ignore_changes = [tags]
  }
}

resource "aws_lb_target_group" "lb_target_groups" {
  for_each = var.lb_target_groups

  name     = each.value.name
  port     = each.value.port
  protocol = each.value.protocol
  vpc_id   = data.aws_vpc.selected.id

  health_check {
    path    = each.value.health_check.path
    matcher = each.value.health_check.matcher
  }
}

resource "aws_lb_listener" "alb_listeners" {
  for_each = var.alb_listeners

  load_balancer_arn = aws_lb.albs[each.value.loadbalancer].arn
  port              = each.value.port
  protocol          = each.value.protocol

  default_action {
    type = each.value.default_action.type

    redirect {
      port        = each.value.default_action.port
      protocol    = each.value.default_action.protocol
      status_code = each.value.default_action.status_code
    }
  }
}