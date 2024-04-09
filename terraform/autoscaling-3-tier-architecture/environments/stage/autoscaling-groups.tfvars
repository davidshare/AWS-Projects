launch_templates = {
  frontend = {
    name          = "frontend-launch-template"
    image_id      = "ami-080e1f13689e07408"
    instance_type = "t2.micro"
    key_name      = "davidessien"
    user_data     = "userdata/deploy-frontend.sh"

    network_interfaces = {
      subnet_id       = "Frontend-1" # https://github.com/davidshare/AWS-Projects/blob/master/terraform/VPC-3-their-architecture/environments/stage/subnets.tfvars#L2C3-L2C14
      security_groups = ["Frontend-Security-Group"]
    }

    tag_specifications = {
      resource_type = "instance"
      tags = {
        Name = "Web Server launch template"
      }
    }
  },
  backend = {
    name          = "backend-launch-template"
    image_id      = "ami-080e1f13689e07408"
    instance_type = "t2.micro"
    key_name      = "davidessien"
    user_data     = "userdata/deploy-backend.sh"

    network_interfaces = {
      subnet_id       = "Backend-1" # https://github.com/davidshare/AWS-Projects/blob/master/terraform/VPC-3-their-architecture/environments/stage/subnets.tfvars#L2C3-L2C14
      security_groups = ["Frontend-Security-Group"]
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
  frontend = {
    name                      = "Frontend-ASG",
    desired_capacity          = 1
    max_size                  = 2,
    min_size                  = 1,
    launch_template           = "frontend"
    health_check_grace_period = 300
    health_check_type         = "ELB"
    subnets                   = ["Frontend-1", "Frontend-2"]
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
  backend = {
    name                      = "Backend-ASG",
    desired_capacity          = 1
    max_size                  = 2,
    min_size                  = 1,
    launch_template           = "backend"
    health_check_grace_period = 300
    health_check_type         = "ELB"
    subnets                   = ["Backend-1", "Backend-2"]
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

autoscaling_attachments = {
  frontend = {
    autoscaling_group = "frontend"
    lb_target_group      = "frontend"
  },
  backend = {
    autoscaling_group = "backend"
    lb_target_group      = "backend"
  },
}