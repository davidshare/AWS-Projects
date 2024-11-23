loadbalancers = {
  primary_frontend_public = {
    name                       = "primary-frontend-public"
    internal                   = false
    load_balancer_type         = "application"
    security_groups            = ["web"]
    subnets                    = ["primary_public_1", "primary_public_2"]
    enable_deletion_protection = true
    access_logs = {
      enabled = true
      bucket  = "my-frontend-lb-logs"
      prefix  = "frontend"
    }
    tags = {
      Tier = "frontend"
    }
  }

  primary_backend_private = {
    name                       = "primary-backend-private"
    internal                   = true
    load_balancer_type         = "network"
    security_groups            = ["backend"]
    subnets                    = ["primary_backend_private_1", "primary_backend_private_2"]
    enable_deletion_protection = false
    access_logs = {
      enabled = false
      bucket  = ""
      prefix  = ""
    }
    tags = {
      Tier = "backend"
    }
  }
}
