albs = {
  frontend = {
    name                       = "frontend loadbalancer"
    internal                   = false
    loadbalancer_type          = "application"
    security_groups            = [alb_security_group]
    subnets                    = ["public1-web", "public2-web"]
    enable_deletion_protection = false

    tags = {
      Name = "Frontend Loadbalancer"
    }
  },
  backend = {
    name                       = "backend loadbalancer"
    internal                   = false
    loadbalancer_type          = "application"
    security_groups            = [alb_security_group]
    subnets                    = ["private1-app", "private2-app"]
    enable_deletion_protection = false

    tags = {
      Name = "Backend Loadbalancer"
    }
  }
}


lb_target_groups = {
  frontend = {
    name     = "Frontend target group"
    port     = 80
    protocol = "HTTP"
    vpc      = "main"

    health_check = {
      path    = "/"
      matcher = 200
    }
  },
  backend = {
    name     = "Backend target group"
    port     = 80
    protocol = "HTTP"
    vpc      = "main"

    health_check = {
      path    = "/"
      matcher = 200
    }
  }
}

lb_target_groups_attachment = {
  frontend = {
    target_arn = "frontend_target_grooup"
    target_id  = "frontend_launch_template"
    port       = 80
  },
  backend = {
    target_arn = "backend_target_grooup"
    target_id  = "backend_launch_template"
    port       = 80
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