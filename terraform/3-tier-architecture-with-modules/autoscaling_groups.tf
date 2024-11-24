variable "autoscaling_groups" {
  description = "Configuration for AWS Auto Scaling Groups"
  type = map(object({
    name                      = string
    max_size                  = number
    min_size                  = number
    desired_capacity          = number
    vpc_zone_identifier       = list(string)
    launch_template           = string
    launch_template_version   = string
    health_check_type         = string
    health_check_grace_period = number
    tags = list(object({
      key                 = string
      value               = string
      propagate_at_launch = bool
    }))
  }))
}


module "autoscaling_group" {
  for_each = var.autoscaling_groups

  source = "../../../terraform-aws-modules/autoscaling_group"

  name                      = each.value.name
  max_size                  = each.value.max_size
  min_size                  = each.value.min_size
  desired_capacity          = each.value.desired_capacity
  vpc_zone_identifier       = [for subnet in each.value.vpc_zone_identifier : module.subnets[subnet].id]
  health_check_type         = each.value.health_check_type
  health_check_grace_period = each.value.health_check_grace_period

  launch_template = {
    id      = module.launch_templates[each.value.launch_template].id
    version = each.value.launch_template_version
  }

  tags = each.value.tags
}


