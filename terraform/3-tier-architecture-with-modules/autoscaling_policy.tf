variable "autoscaling_group_policies" {
  description = "Configuration for Auto Scaling Group Policies"
  type = map(object({
    name                      = string
    autoscaling_group         = string
    policy_type               = string
    adjustment_type           = optional(string) # Allow null values
    scaling_adjustment        = optional(number) # Allow null values
    cooldown                  = optional(number) # Allow null values
    estimated_instance_warmup = optional(number) # Allow null values
    metric_aggregation_type   = optional(string) # Allow null values
    min_adjustment_magnitude  = optional(number) # Allow null values
    target_tracking_configuration = optional(object({
      predefined_metric_specification = optional(object({
        predefined_metric_type = string
      }))
      target_value = number
    })) # Allow null values
    step_adjustments = optional(list(object({
      metric_interval_lower_bound = number
      metric_interval_upper_bound = optional(number) # Allow null values
      scaling_adjustment          = number
    }))) # Allow null values
  }))
}



module "autoscaling_policy" {
  for_each = var.autoscaling_group_policies

  source = "../../../terraform-aws-modules/autoscaling_policy"

  name                          = each.value.name
  autoscaling_group_name        = module.autoscaling_group[each.value.autoscaling_group].autoscaling_group_name
  policy_type                   = each.value.policy_type
  adjustment_type               = each.value.adjustment_type
  scaling_adjustment            = each.value.scaling_adjustment
  cooldown                      = each.value.cooldown
  estimated_instance_warmup     = each.value.estimated_instance_warmup
  metric_aggregation_type       = each.value.metric_aggregation_type
  min_adjustment_magnitude      = each.value.min_adjustment_magnitude
  target_tracking_configuration = each.value.target_tracking_configuration
  step_adjustment               = each.value.step_adjustments
}