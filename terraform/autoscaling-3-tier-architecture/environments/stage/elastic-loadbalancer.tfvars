albs = {
  frontend = {
    name                       = "frontend"
    internal                   = false
    load_balancer_type         = "application"
    security_groups            = ["ALB-Security-Group"]
    subnets                    = ["Frontend-1", "Frontend-2"]
    enable_deletion_protection = false

    tags = {
      Name = "Frontend-Loadbalancer"
    }
  },
  backend = {
    name                       = "backend"
    internal                   = true
    load_balancer_type         = "application"
    security_groups            = ["ALB-Security-Group"]
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
    vpc      = "main"

    health_check = {
      path    = "/"
      matcher = 200
    }
  },
  backend = {
    name     = "Backend"
    port     = 80
    protocol = "HTTP"
    vpc      = "main"

    health_check = {
      path    = "/"
      matcher = 200
    }
  }
}

alb_listeners = {
  frontend = {
    loadbalancer = "frontend"
    port         = 80
    protocol     = "HTTP"

    default_action = {
      type        = "redirect"
      port        = 443
      protocol    = "HTTPS"
      status_code = "HTTP_301"
    }
  },
  backend = {
    loadbalancer = "backend"
    port         = 80
    protocol     = "HTTP"

    default_action = {
      type        = "redirect"
      port        = 443
      protocol    = "HTTPS"
      status_code = "HTTP_301"
    }
  }
}