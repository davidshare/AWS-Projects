variable "loadbalancers" {}
variable "lb_target_groups" {}
variable "alb_listeners" {}
# variable "lb_listener_rules" {}

resource "aws_lb" "loadbalancers" {
  for_each = var.loadbalancers

  name                       = each.value.name
  internal                   = each.value.internal
  load_balancer_type         = each.value.load_balancer_type
  security_groups            = [for sg in each.value.security_groups : aws_security_group.security_groups[sg].id]
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
  vpc_id   = local.vpc_id[each.value.vpc].id

  health_check {
    path                = each.value.health_check.path
    protocol            = each.value.health_check.protocol
    matcher             = each.value.health_check.matcher
    interval            = each.value.health_check.interval
    timeout             = each.value.health_check.timeout
    healthy_threshold   = each.value.health_check.healthy_threshold
    unhealthy_threshold = each.value.health_check.unhealthy_threshold
  }
}

resource "aws_lb_listener" "lb_listeners" {
  for_each = var.alb_listeners

  load_balancer_arn = aws_lb.loadbalancers[each.value.loadbalancer].arn
  port              = each.value.port
  protocol          = each.value.protocol

  default_action {
    type             = each.value.default_action.type
    target_group_arn = aws_lb_target_group.lb_target_groups[each.value.default_action.target_group].arn
  }
}
