autoscaling_group_policies = {
  frontend_scale_down = {
    name                          = "frontend-scale-in-policy"
    autoscaling_group             = "frontend_asg"
    policy_type                   = "StepScaling"
    adjustment_type               = "ChangeInCapacity"
    scaling_adjustment            = null
    cooldown                      = null
    estimated_instance_warmup     = null
    metric_aggregation_type       = "Average"
    min_adjustment_magnitude      = null
    target_tracking_configuration = null
    step_adjustments = [
      {
        metric_interval_lower_bound = 0
        metric_interval_upper_bound = 10
        scaling_adjustment          = -1
      },
      {
        metric_interval_lower_bound = 10
        metric_interval_upper_bound = null
        scaling_adjustment          = -2
      }
    ]
  }

  frontend_scale_up = {
    name                      = "frontend-scale-out-policy"
    autoscaling_group         = "frontend_asg"
    policy_type               = "TargetTrackingScaling"
    adjustment_type           = null
    scaling_adjustment        = null
    cooldown                  = null
    estimated_instance_warmup = 300
    metric_aggregation_type   = null
    min_adjustment_magnitude  = null
    target_tracking_configuration = {
      predefined_metric_specification = {
        predefined_metric_type = "ASGAverageCPUUtilization"
        resource_label         = "frontend_asg"
      }
      target_value = 70
    }
    step_adjustments = []
  }

  backend_scale_down = {
    name                          = "backend-scale-in-policy"
    autoscaling_group             = "backend_asg"
    policy_type                   = "StepScaling"
    adjustment_type               = "PercentChangeInCapacity"
    scaling_adjustment            = null
    cooldown                      = null
    estimated_instance_warmup     = null
    metric_aggregation_type       = "Average"
    min_adjustment_magnitude      = 1
    target_tracking_configuration = null
    step_adjustments = [
      {
        metric_interval_lower_bound = 0
        metric_interval_upper_bound = 5
        scaling_adjustment          = -2
      },
      {
        metric_interval_lower_bound = 5
        metric_interval_upper_bound = null
        scaling_adjustment          = -3
      }
    ]
  }

  backend_scale_up = {
    name                      = "backend-scale-out-policy"
    autoscaling_group         = "backend_asg"
    policy_type               = "TargetTrackingScaling"
    adjustment_type           = null
    scaling_adjustment        = null
    cooldown                  = null
    estimated_instance_warmup = 300
    metric_aggregation_type   = null
    min_adjustment_magnitude  = null
    target_tracking_configuration = {
      predefined_metric_specification = {
        predefined_metric_type = "ASGAverageCPUUtilization"
        resource_label         = "backend_asg"
      }
      target_value = 80
    }
    step_adjustments = []
  }
}
