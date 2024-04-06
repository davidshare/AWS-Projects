launch_templates = {
  frontend_launch_template = {
    name          = "frontend launch template"
    image_id      = "ami-05ff6a2c3554c7df6"
    instance_type = "t2.micro"
    key_name      = "davidessien"
    user_data     = "files/deploy-frontend.sh"

    network_interfaces = {
      subnet_id      = "public1-web" # https://github.com/davidshare/AWS-Projects/blob/master/terraform/VPC-3-their-architecture/environments/stage/subnets.tfvars#L2C3-L2C14
      security_group = "frontend-sg"
    }

    tag_specifications = {
      resource_type = "instance"
      tags = {
        Name = "Web Server launch template"
      }
    }
  },
  backend-launch-template = {
    name          = "backend launch template"
    image_id      = "ami-05ff6a2c3554c7df6"
    instance_type = "t2.micro"
    key_name      = "davidessien"
    user_data     = "files/deploy-backend.sh"

    network_interfaces = {
      subnet_id      = "private1-app" # https://github.com/davidshare/AWS-Projects/blob/master/terraform/VPC-3-their-architecture/environments/stage/subnets.tfvars#L2C3-L2C14
      security_group = "App server-sg"
    }

    tag_specifications = {
      resource_type = "instance"
      tags = {
        Name = "AppServer launch template"
      }
    }
  }
}

autoscaling_groups = {
  frontend-asg = {
    name                      = "Frontend ASG",
    desired_capacity          = 3
    max_size                  = 12,
    min_size                  = 2,
    launch_template           = "frontend-launch-template"
    health_check_grace_period = 300
    health_check_type         = "ELB"
    vpc_zone_identifier       = ["public1-web", "public2-web"]
    force_delete              = true
    enabled_metrics = [
      "GroupMinSize",
      "GroupMaxSize",
      "GroupDesiredCapacity",
      "GroupInServiceInstances",
      "GroupTotalInstances"
    ]
    metrics_granularity = "1Minute"
  },
  backend-asg = {
    name                      = "Backend ASG",
    desired_capacity          = 3
    max_size                  = 12,
    min_size                  = 2,
    launch_template           = "backend-launch-template"
    health_check_grace_period = 300
    health_check_type         = "ELB"
    vpc_zone_identifier       = ["private-app", "private2-app"]
    force_delete              = true
    enabled_metrics = [
      "GroupMinSize",
      "GroupMaxSize",
      "GroupDesiredCapacity",
      "GroupInServiceInstances",
      "GroupTotalInstances"
    ]
    metrics_granularity = "1Minute"
  }
}