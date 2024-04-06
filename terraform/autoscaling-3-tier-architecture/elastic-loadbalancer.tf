variable "albs" {}
variable "lb_target_groups" {}
variable "alb_listeners" {}
variable "target_group_attachments" {}

resource "aws_lb" "albs" {
  for_each                   = var.albs
  name                       = each.value.name
  internal                   = each.value.internal
  load_balancer_type         = each.value.load_balancer_type
  security_groups            = each.value.security_groups
  subnets                    = [for i in aws_subnet.public_subnet : i.id]
  enable_deletion_protection = each.value.enable_deletion_protection

  tags = merge(each.value.tags, local.tags)
}

resource "aws_lb_target_group" "lb_target_groups" {
  for_each = var.lb_target_groups

  name     = each.value.name
  port     = each.value.port
  protocol = each.value.protocol
  vpc_id   = each.value.vpc

  health_check {
    path    = each.value.health_check.path
    matcher = each.value.health_check.matcher
  }
}

resource "aws_target_group_attachment" "target_group_attachments" {
  for_each = var.target_group_attachments

  target_group_arn = each.value.target_arn
  target_id        = each.value.target_id
  port             = each.value.port
}

resource "aws_lb_listener" "alb_listeners" {
  for_each = var.alb_listeners

  load_balancer_arn = each.value.lb_arn
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