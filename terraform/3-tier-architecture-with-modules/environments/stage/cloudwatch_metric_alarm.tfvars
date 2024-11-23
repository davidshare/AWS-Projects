cloudwatch_metric_alarms = {
  frontend_high_cpu = {
    alarm_name          = "web-tier-high-cpu"
    comparison_operator = "GreaterThanOrEqualToThreshold"
    evaluation_periods  = 3
    metric_name         = "CPUUtilization"
    namespace           = "AWS/EC2"
    period              = 300
    statistic           = "Average"
    threshold           = 80
    alarm_description   = "Triggers when CPU utilization exceeds 80% in the web tier"
    alarm_actions       = ["frontend_scale_down"]
    ok_actions          = ["frontend_scale_up"]
    dimensions = {
      autoscaling_group = "frontend_asg"
    }
  }

  frontend_low_cpu = {
    alarm_name          = "web-tier-low-cpu"
    comparison_operator = "LessThanOrEqualToThreshold"
    evaluation_periods  = 3
    metric_name         = "CPUUtilization"
    namespace           = "AWS/EC2"
    period              = 300
    statistic           = "Average"
    threshold           = 20
    alarm_description   = "Triggers when CPU utilization falls below 20% in the web tier"
    alarm_actions       = ["frontend_scale_up"]
    ok_actions          = ["frontend_scale_down"]
    dimensions = {
      autoscaling_group = "frontend_asg"
    }
  }

  backend_high_latency = {
    alarm_name          = "backend-tier-high-latency"
    comparison_operator = "GreaterThanThreshold"
    evaluation_periods  = 3
    metric_name         = "Latency"
    namespace           = "AWS/ApplicationELB"
    period              = 300
    statistic           = "Average"
    threshold           = 0.5
    alarm_description   = "Triggers when backend latency exceeds 0.5 seconds"
    alarm_actions       = ["backend_scale_down"]
    ok_actions          = ["backend_scale_up"]
    dimensions = {
      LoadBalancer = "primary_backend_private"
      TargetGroup  = "backend_tg"
    }
  }

  backend_low_healthy_hosts = {
    alarm_name          = "backend-tier-low-healthy-hosts"
    comparison_operator = "LessThanThreshold"
    evaluation_periods  = 2
    metric_name         = "HealthyHostCount"
    namespace           = "AWS/NetworkELB"
    period              = 60
    statistic           = "Average"
    threshold           = 2
    alarm_description   = "Triggers when the number of healthy backend hosts falls below 2"
    alarm_actions       = ["backend_topic"]
    ok_actions          = []
    dimensions = {
      LoadBalancer = "primary_backend_private"
      TargetGroup  = "backend_tg"
    }
  }
}
