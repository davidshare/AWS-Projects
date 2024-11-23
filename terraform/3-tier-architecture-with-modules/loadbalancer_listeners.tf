variable "lb_listeners" {
  description = "Configuration for Load Balancer Listeners"
  type = map(object({
    load_balancer   = string
    port            = number
    protocol        = string
    ssl_policy      = string
    certificate_arn = string
    default_actions = list(object({
      type         = string
      target_group = string
      order        = number
    }))
  }))
}

module "lb_listener" {
  for_each = var.lb_listeners

  source = "../../../terraform-aws-modules/lb_listener"

  load_balancer_arn = module.loadbalancer[each.value.load_balancer].arn
  port              = each.value.port
  protocol          = each.value.protocol
  ssl_policy        = each.value.ssl_policy
  certificate_arn   = each.value.certificate_arn
  default_actions = [
    for action in each.value.default_actions : {
      type             = action.type
      target_group_arn = module.lb_target_group[action.target_group].arn
      order            = action.order
    }
  ]
}
