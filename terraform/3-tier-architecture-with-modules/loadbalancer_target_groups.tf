variable "lb_target_groups" {
  description = "Configuration for Load Balancer Target Groups"
  type = map(object({
    name               = string
    protocol           = string
    port               = number
    vpc                = string
    target_type        = string
    preserve_client_ip = bool
    health_check = object({
      enabled             = bool
      protocol            = string
      path                = string
      port                = string
      interval            = number
      timeout             = number
      healthy_threshold   = number
      unhealthy_threshold = number
      matcher             = string
    })
    stickiness = object({
      cookie_duration = number
      cookie_name     = string
      type            = string
      enabled         = bool
    })
    tags = map(string)
  }))
}

module "lb_target_group" {
  for_each = var.lb_target_groups

  source = "github.com/davidshare/terraform-aws-modules//lb_target_group?ref=lb_target_group-v1.0.0"

  name               = each.value.name
  protocol           = each.value.protocol
  port               = each.value.port
  vpc_id             = module.vpc[each.value.vpc].id
  target_type        = each.value.target_type
  preserve_client_ip = each.value.preserve_client_ip

  health_check = {
    enabled             = each.value.health_check.enabled
    protocol            = each.value.health_check.protocol
    path                = each.value.health_check.path
    port                = each.value.health_check.port
    interval            = each.value.health_check.interval
    timeout             = each.value.health_check.timeout
    healthy_threshold   = each.value.health_check.healthy_threshold
    unhealthy_threshold = each.value.health_check.unhealthy_threshold
    matcher             = each.value.health_check.matcher
  }

  stickiness = {
    cookie_duration = each.value.stickiness.cookie_duration
    type            = each.value.stickiness.type
    enabled         = each.value.stickiness.enabled
    cookie_name     = each.value.stickiness.cookie_name
  }

  tags = each.value.tags
}