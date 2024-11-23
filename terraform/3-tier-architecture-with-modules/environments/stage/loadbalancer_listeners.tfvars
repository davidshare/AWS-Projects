lb_listeners = {
  frontend_listener = {
    load_balancer   = "primary_frontend_public"
    port            = 80
    protocol        = "HTTP"
    ssl_policy      = null
    certificate_arn = null
    default_actions = [
      {
        type         = "forward"
        target_group = "frontend_tg"
        order        = 1
      }
    ]
  }

  backend_listener = {
    load_balancer   = "primary_backend_private"
    port            = 80
    protocol        = "HTTP"
    ssl_policy      = null
    certificate_arn = null
    default_actions = [
      {
        type         = "forward"
        target_group = "backend_tg"
        order        = 1
      }
    ]
  }
}
