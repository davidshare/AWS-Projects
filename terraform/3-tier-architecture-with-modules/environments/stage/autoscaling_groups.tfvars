autoscaling_groups = {
  frontend_asg = {
    name                      = "frontend-asg"
    max_size                  = 5
    min_size                  = 1
    desired_capacity          = 1
    vpc_zone_identifier       = ["primary_public_1", "primary_public_2"]
    launch_template           = "frontend"
    launch_template_version   = "$latest"
    health_check_type         = "ELB"
    health_check_grace_period = 300
    tags = [
      {
        key                 = "Tier"
        value               = "frontend"
        propagate_at_launch = true
      }
    ]
  }

  backend_asg = {
    name                      = "backend-asg"
    max_size                  = 10
    min_size                  = 1
    desired_capacity          = 1
    vpc_zone_identifier       = ["primary_backend_private_1", "primary_backend_private_2"]
    launch_template           = "backend"
    launch_template_version   = "$latest"
    health_check_type         = "ELB"
    health_check_grace_period = 400
    tags = [
      {
        key                 = "Tier"
        value               = "backend"
        propagate_at_launch = true
      }
    ]
  }
}
