lb_target_groups = {
  frontend_tg = {
    name               = "frontend-tg"
    protocol           = "HTTP"
    port               = 80
    vpc                = "main"
    target_type        = "instance"
    preserve_client_ip = null
    health_check = {
      enabled             = true
      protocol            = "HTTP"
      path                = "/"
      port                = "traffic-port"
      interval            = 30
      timeout             = 5
      healthy_threshold   = 3
      unhealthy_threshold = 3
      matcher             = "200"
    }
    stickiness = {
      enabled         = true
      type            = "lb_cookie"
      cookie_duration = 86400
      cookie_name     = null
    }
    tags = {
      Tier = "frontend"
    }
  }

  backend_tg = {
    name               = "backend-tg"
    protocol           = "HTTPS"
    port               = 443
    vpc                = "main"
    target_type        = "instance"
    preserve_client_ip = null
    health_check = {
      enabled             = true
      protocol            = "HTTPS"
      path                = "/"
      port                = "443"
      interval            = 15
      timeout             = 5
      healthy_threshold   = 2
      unhealthy_threshold = 2
      matcher             = "200-299"
    }
    stickiness = {
      enabled         = false
      type            = "lb_cookie"
      cookie_name     = null
      cookie_duration = null
    }
    tags = {
      Tier = "backend"
    }
  }
}
