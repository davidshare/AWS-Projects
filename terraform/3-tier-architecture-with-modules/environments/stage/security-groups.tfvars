security_groups = {
  "web" = {
    name                   = "web"
    name_prefix            = "web"
    description            = "Security group for web servers"
    vpc_name               = "main"
    revoke_rules_on_delete = true
    tags = {
      Name = "WebSG"
    }
  },
  "backend" = {
    name                   = "backend"
    name_prefix            = "backend"
    description            = "Security group for backend services"
    vpc_name               = "main"
    revoke_rules_on_delete = true
    tags = {
      Name = "BackendSG"
    }
  },
  "database" = {
    name                   = "database"
    name_prefix            = "db"
    description            = "Security group for database servers"
    vpc_name               = "main"
    revoke_rules_on_delete = true
    tags = {
      Name = "DbSG"
    }
  },
  "frontend_lb" = {
    name                   = "frontend-lb"
    name_prefix            = "frlb"
    description            = "Security group for frontend load balancer"
    vpc_name               = "main"
    revoke_rules_on_delete = true
    tags = {
      Name = "FrontendLBSG"
    }
  },
  "backend_lb" = {
    name                   = "backend-lb"
    name_prefix            = "bklb"
    description            = "Security group for backend load balancer"
    vpc_name               = "main"
    revoke_rules_on_delete = true
    tags = {
      Name = "BackendLBSG"
    }
  }
}
