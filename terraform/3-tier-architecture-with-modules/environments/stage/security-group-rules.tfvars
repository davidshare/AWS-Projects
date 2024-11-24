ingress_rules = [
  # Frontend Load Balancer Security Group Rules
  {
    security_group_id            = "frontend_lb"
    description                  = "Allow HTTP from anywhere"
    from_port                    = 80
    to_port                      = 80
    protocol                     = "tcp"
    referenced_security_group_id = ""
    cidr_ipv4                    = "0.0.0.0/0"
    cidr_ipv6                    = ""
    prefix_list_ids              = ""
    tags = {
      "Name" = "Frontend LB HTTP Ingress"
    }
  },
  {
    security_group_id            = "frontend_lb"
    description                  = "Allow HTTPS from anywhere"
    from_port                    = 443
    to_port                      = 443
    protocol                     = "tcp"
    referenced_security_group_id = ""
    cidr_ipv4                    = "0.0.0.0/0"
    cidr_ipv6                    = ""
    prefix_list_ids              = ""
    tags = {
      "Name" = "Frontend LB HTTPS Ingress"
    }
  },

  # Backend Load Balancer Security Group Rules
  {
    security_group_id            = "backend_lb"
    description                  = "Allow traffic from web tier"
    from_port                    = 80
    to_port                      = 80
    protocol                     = "tcp"
    referenced_security_group_id = "web"
    cidr_ipv4                    = ""
    cidr_ipv6                    = ""
    prefix_list_ids              = ""
    tags = {
      "Name" = "Backend LB Web Tier Ingress"
    }
  },
  # Database Security Group Rules
  {
    security_group_id            = "database"
    description                  = "Allow MySQL access from backend servers"
    from_port                    = 3306
    to_port                      = 3306
    protocol                     = "tcp"
    referenced_security_group_id = "backend"
    cidr_ipv4                    = ""
    cidr_ipv6                    = ""
    prefix_list_ids              = ""
    tags = {
      "Name" = "MySQL Ingress Rule"
    }
  },
  {
    security_group_id            = "database"
    description                  = "Allow access from database"
    from_port                    = 5432
    to_port                      = 5432
    protocol                     = "tcp"
    referenced_security_group_id = "database"
    cidr_ipv4                    = ""
    cidr_ipv6                    = ""
    prefix_list_ids              = ""
    tags = {
      "Name" = "PostgreSQL Ingress Rule"
    }
  },

  {
    security_group_id            = "backend"
    description                  = "Allow traffic from backend load balancer"
    from_port                    = 8080
    to_port                      = 8080
    protocol                     = "tcp"
    referenced_security_group_id = "backend_lb"
    cidr_ipv4                    = ""
    cidr_ipv6                    = ""
    prefix_list_ids              = ""
    tags = {
      "Name" = "Backend from Backend LB Ingress"
    }
  },

  {
    security_group_id            = "web"
    description                  = "Allow traffic from frontend load balancer"
    from_port                    = 80
    to_port                      = 80
    protocol                     = "tcp"
    referenced_security_group_id = "frontend_lb"
    cidr_ipv4                    = ""
    cidr_ipv6                    = ""
    prefix_list_ids              = ""
    tags = {
      "Name" = "Web from Frontend LB Ingress"
    }
  },
  {
    security_group_id            = "web"
    description                  = "Allow HTTPS access from anywhere"
    from_port                    = 443
    to_port                      = 443
    protocol                     = "tcp"
    referenced_security_group_id = ""
    cidr_ipv4                    = "0.0.0.0/0"
    cidr_ipv6                    = ""
    prefix_list_ids              = ""
    tags = {
      "Name" = "Web Ingress Rule HTTPS"
    }
  }
]

# Egress Rules
egress_rules = [
  {
    security_group_id            = "database"
    description                  = "Allow outbound traffic"
    from_port                    = null
    to_port                      = null
    protocol                     = "-1"
    referenced_security_group_id = ""
    cidr_ipv4                    = "0.0.0.0/0"
    cidr_ipv6                    = ""
    prefix_list_ids              = ""
    tags = {
      "Name" = "Database-SG-Egress"
    }
  },

  {
    security_group_id            = "backend"
    description                  = "Allow outbound traffic"
    from_port                    = null
    to_port                      = null
    protocol                     = "-1"
    referenced_security_group_id = ""
    cidr_ipv4                    = "0.0.0.0/0"
    cidr_ipv6                    = ""
    prefix_list_ids              = ""
    tags = {
      "Name" = "Backend-SG-Egress"
    }
  },

  {
    security_group_id            = "web"
    description                  = "Allow outbound traffic"
    from_port                    = null
    to_port                      = null
    protocol                     = "-1"
    referenced_security_group_id = ""
    cidr_ipv4                    = "0.0.0.0/0"
    cidr_ipv6                    = ""
    prefix_list_ids              = ""
    tags = {
      "Name" = "Web-SG-Egress"
    }
  },

  {
    security_group_id            = "frontend_lb"
    description                  = "Allow outbound traffic to web tier"
    from_port                    = 80
    to_port                      = 80
    protocol                     = "tcp"
    referenced_security_group_id = "web"
    cidr_ipv4                    = ""
    cidr_ipv6                    = ""
    prefix_list_ids              = ""
    tags = {
      "Name" = "Frontend-LB-to-Web-Egress"
    }
  },

  {
    security_group_id            = "backend_lb"
    description                  = "Allow outbound traffic to backend tier"
    from_port                    = 8080
    to_port                      = 8080
    protocol                     = "tcp"
    referenced_security_group_id = "backend"
    cidr_ipv4                    = ""
    cidr_ipv6                    = ""
    prefix_list_ids              = ""
    tags = {
      "Name" = "Backend-LB-to-Backend-Egress"
    }
  }
]
