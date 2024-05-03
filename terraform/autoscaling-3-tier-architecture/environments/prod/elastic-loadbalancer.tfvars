loadbalancers = {
  frontend = {
    name                       = "frontend"
    internal                   = false
    load_balancer_type         = "application"
    security_groups            = ["Frontend-ALB-Security-Group"]
    subnets                    = ["Frontend-1", "Frontend-2"]
    enable_deletion_protection = false

    tags = {
      Name = "Frontend-Loadbalancer"
    }
  },
  backend = {
    name                       = "backend"
    internal                   = true
    load_balancer_type         = "network"
    security_groups            = ["Backend-NLB-Security-Group"]
    subnets                    = ["Backend-1", "Backend-2"]
    enable_deletion_protection = false

    tags = {
      Name = "Backend-Loadbalancer"
    }
  }
}

lb_target_groups = {
  frontend = {
    name     = "Frontend"
    port     = 80
    protocol = "HTTP"
    vpc      = "tersu"

    health_check = {
      path                = "/"
      protocol            = "HTTP"
      matcher             = 200
      interval            = 15
      timeout             = 3
      healthy_threshold   = 2
      unhealthy_threshold = 2
    }
  },
  backend = {
    name     = "Backend"
    port     = 80
    protocol = "HTTP"
    vpc      = "tersu"

    health_check = {
      path                = "/"
      protocol            = "HTTP"
      matcher             = 200
      interval            = 15
      timeout             = 3
      healthy_threshold   = 2
      unhealthy_threshold = 2
    }
  }
}

alb_listeners = {
  frontend = {
    loadbalancer = "frontend"
    port         = 80
    protocol     = "HTTP"

    default_action = {
      type         = "forward"
      target_group = "frontend"
    }
  },
  backend = {
    loadbalancer = "backend"
    port         = 80
    protocol     = "HTTP"

    default_action = {
      type         = "forward"
      target_group = "backend"
    }
  }
}