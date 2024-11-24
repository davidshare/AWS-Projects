variable "loadbalancers" {
  description = "Configuration for AWS load balancers"
  type = map(object({
    name                       = string
    internal                   = bool
    load_balancer_type         = string
    security_groups            = list(string)
    subnets                    = list(string)
    enable_deletion_protection = bool
    access_logs = object({
      enabled = bool
      bucket  = string
      prefix  = string
    })
    tags = map(string)
  }))
}


module "loadbalancer" {
  for_each = var.loadbalancers

  source = "../../../terraform-aws-modules/alb"

  name                       = each.value.name
  internal                   = each.value.internal
  load_balancer_type         = each.value.load_balancer_type
  security_groups            = [for sg in each.value.security_groups : module.security_group[sg].id]
  subnets                    = [for sb in each.value.subnets : module.subnets[sb].id]
  enable_deletion_protection = each.value.enable_deletion_protection
  access_logs = {
    enabled = each.value.access_logs.enabled
    bucket  = each.value.access_logs.bucket
    prefix  = each.value.access_logs.prefix
  }
  tags = merge(each.value.tags, local.tags)
}
