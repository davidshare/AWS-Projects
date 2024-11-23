locals {
  alarm_configs = {
    frontend_low_cpu = {
      alarm_actions = [
        module.autoscaling_policy["frontend_scale_down"].arn
      ]
      ok_actions = [
        module.autoscaling_policy["frontend_scale_up"].arn
      ]
      dimensions = {
        AutoScalingGroupName = module.autoscaling_group["frontend_asg"].autoscaling_group_arn
      }
    }

    frontend_high_cpu = {
      alarm_actions = [
        module.autoscaling_policy["frontend_scale_up"].arn
      ]
      ok_actions = [
        module.autoscaling_policy["frontend_scale_down"].arn
      ]
      dimensions = {
        AutoScalingGroupName = module.autoscaling_group["frontend_asg"].autoscaling_group_arn
      }
    }

    backend_high_latency = {
      alarm_actions = [
        module.autoscaling_policy["backend_scale_down"].arn
      ]
      ok_actions = [
        module.autoscaling_policy["backend_scale_up"].arn
      ]
      dimensions = {
        LoadBalancer = module.loadbalancer["primary_backend_private"].arn
        TargetGroup  = module.lb_target_group["backend_tg"].arn
      }
    }

    backend_low_healthy_hosts = {
      alarm_actions = [
        module.sns_topic["backend_topic"].arn
      ]
      ok_actions = []
      dimensions = {
        LoadBalancer = module.loadbalancer["primary_backend_private"].arn
        TargetGroup  = module.lb_target_group["backend_tg"].arn
      }
    }
  }
}

variable "cloudwatch_metric_alarms" {
  description = "Configuration for cloudwatch metrics alarm"
  type = map(object({
    alarm_name          = string
    comparison_operator = string
    evaluation_periods  = number
    metric_name         = string
    namespace           = string
    period              = number
    statistic           = string
    threshold           = number
    alarm_description   = string
    alarm_actions       = list(string)
    ok_actions          = list(string)
    dimensions          = map(string)
  }))
}

module "cloudwatch_metric_alarm" {
  for_each = var.cloudwatch_metric_alarms

  source = "../../../terraform-aws-modules/cloudwatch_metric_alarm"

  alarm_name          = each.value.alarm_name
  comparison_operator = each.value.comparison_operator
  evaluation_periods  = each.value.evaluation_periods
  metric_name         = each.value.metric_name
  namespace           = each.value.namespace
  period              = each.value.period
  statistic           = each.value.statistic
  threshold           = each.value.threshold
  alarm_description   = each.value.alarm_description
  alarm_actions       = local.alarm_configs[each.key].alarm_actions
  ok_actions          = local.alarm_configs[each.key].ok_actions
  dimensions          = local.alarm_configs[each.key].dimensions
}
