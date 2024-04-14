security_groups = {
  "Frontend-ALB-Security-Group" = {
    name        = "Frontend-ALB-Security-Group"
    description = "Enable http/https access on port 80/443"
    vpc         = "tersu"
    tags = {
      Name = "Frontend-ALB-Security-Group"
    }
  }

  "Backend-NLB-Security-Group" = {
    name        = "Backend-NLB-Security-Group"
    description = "Enable http/https access on port 5000"
    vpc         = "tersu"
    tags = {
      Name = "Backend-NLB-Security-Group"
    }
  },

  "Frontend-Security-Group" = {
    name        = "Frontend-Security-Group"
    description = "Enable http, https, and ssh access on ports 80, 443, and 22 respectively"
    vpc         = "tersu"
    tags = {
      Name = "Frontend-Security-Group"
    }
  }

  "Backend-Security-Group" = {
    name        = "Backend-Security-Group"
    description = "Security group for the backend services in a private subnet"
    vpc         = "tersu"
    tags = {
      Name = "Backend-Security-Group"
    }
  }

  "Database-Security-Group" = {
    name        = "Database-Security-Group"
    description = "Control traffic to the database"
    vpc         = "tersu"
    tags = {
      Name = "Database-Security-Group"
    }
  }
}

security_group_rules = [
  ################ Database security group rules
  {
    security_group        = "Database-Security-Group"
    type                  = "ingress"
    description           = "allow inbound traffic on port 5432 from the backend"
    from_port             = 5432
    to_port               = 5432
    protocol              = "tcp"
    source_security_group = "Backend-Security-Group"
  },
  {
    security_group = "Database-Security-Group"
    type           = "egress"
    description    = "allow outbound traffic on port 5432 to the backend"
    from_port      = 0
    to_port        = 0
    protocol       = "-1"
    cidr_blocks    = ["0.0.0.0/0"]
  },

  ################ Backend security group rules
  {
    security_group        = "Backend-Security-Group"
    type                  = "ingress"
    description           = "allow http access on port 5000 from the frontend services"
    from_port             = 5000
    to_port               = 5000
    protocol              = "tcp"
    source_security_group = "Frontend-Security-Group"
  },

  {
    security_group = "Backend-Security-Group"
    type           = "egress"
    description    = "allow outbound traffic"
    from_port      = 0
    to_port        = 0
    protocol       = "-1"
    cidr_blocks    = ["0.0.0.0/0"]
  },
  {
    security_group = "Backend-Security-Group"
    type           = "ingress"
    description    = "allow ssh access on port 22 to the backend services"
    from_port      = 22
    to_port        = 22
    protocol       = "tcp"
    source_security_group = "Frontend-Security-Group"
  },
  {
    security_group        = "Backend-NLB-Security-Group"
    type                  = "ingress"
    description           = "allow http access on port 5000 from the frontend services"
    from_port             = 5000
    to_port               = 5000
    protocol              = "tcp"
    source_security_group = "Frontend-Security-Group"
  },
  {
    security_group = "Backend-NLB-Security-Group"
    type           = "egress"
    description    = "allow access on all ports on all ips out of the service"
    from_port      = 5000
    to_port        = 5000
    protocol       = "-1"
    cidr_blocks    = ["0.0.0.0/0"]
  },
  {
    security_group = "Frontend-Security-Group"
    type           = "ingress"
    description    = "allow http access on port 80 to the frontend services"
    from_port      = 80
    to_port        = 80
    protocol       = "tcp"
    cidr_blocks    = ["0.0.0.0/0"]
  },
  {
    security_group = "Frontend-Security-Group"
    type           = "ingress"
    description    = "allow https access on port 443 to the frontend services"
    from_port      = 443
    to_port        = 443
    protocol       = "tcp"
    cidr_blocks    = ["0.0.0.0/0"]
  },
  {
    security_group = "Frontend-Security-Group"
    type           = "ingress"
    description    = "allow ssh access on port 22 to the frontend services"
    from_port      = 22
    to_port        = 22
    protocol       = "tcp"
    cidr_blocks    = ["0.0.0.0/0"]
  },
  {
    security_group = "Frontend-Security-Group"
    type           = "egress"
    description    = "allow outbout traffic to all services"
    from_port      = 0
    to_port        = 0
    protocol       = "-1"
    cidr_blocks    = ["0.0.0.0/0"]
  },
  {
    security_group = "Frontend-ALB-Security-Group"
    type           = "ingress"
    description    = "allow http access to the frontend on all ips"
    from_port      = 80
    to_port        = 80
    protocol       = "tcp"
    cidr_blocks    = ["0.0.0.0/0"]
  },
  {
    security_group = "Frontend-ALB-Security-Group"
    type           = "ingress"
    description    = "allow https access to the frontend on all ips"
    from_port      = 443
    to_port        = 443
    protocol       = "tcp"
    cidr_blocks    = ["0.0.0.0/0"]
  },
  {
    security_group = "Frontend-ALB-Security-Group"
    type           = "egress"
    description    = "allow outbout traffic to all services"
    from_port      = 0
    to_port        = 0
    protocol       = "-1"
    cidr_blocks    = ["0.0.0.0/0"]
  }
]
