security_groups = {
  "web" = {
    name        = "web-sg"
    name_prefix = "web"
    description = "Security group for web servers"
    vpc_name    = "main" # Replace with the actual VPC ID
    ingress_rules = [
      {
        from_port        = 80
        to_port          = 80
        protocol         = "tcp"
        cidr_blocks      = ["0.0.0.0/0"]
        ipv6_cidr_blocks = []
        prefix_list_ids  = []
        security_groups  = []
        self             = false
        description      = "Allow HTTP"
      },
      {
        from_port        = 443
        to_port          = 443
        protocol         = "tcp"
        cidr_blocks      = ["0.0.0.0/0"]
        ipv6_cidr_blocks = []
        prefix_list_ids  = []
        security_groups  = []
        self             = false
        description      = "Allow HTTPS"
      },
      {
        from_port        = 3000
        to_port          = 3000
        protocol         = "tcp"
        cidr_blocks      = ["10.0.0.0/16"] # Allow backend access
        ipv6_cidr_blocks = []
        prefix_list_ids  = []
        security_groups  = ["backend"] # Allow access from backend
        self             = false
        description      = "Allow access from backend"
      }
    ]
    egress_rules = [
      {
        from_port        = 0
        to_port          = 0
        protocol         = "-1"
        cidr_blocks      = ["0.0.0.0/0"]
        ipv6_cidr_blocks = []
        prefix_list_ids  = []
        security_groups  = []
        self             = false
        description      = "Allow all outbound traffic"
      }
    ]
    revoke_rules_on_delete = true
    tags = {
      Name        = "WebSG"
      Environment = "Production"
    }
  },
  "backend" = {
    name        = "backend-sg"
    name_prefix = "backend"
    description = "Security group for backend services"
    vpc_name    = "main" # Replace with the actual VPC ID
    ingress_rules = [
      {
        from_port        = 8080
        to_port          = 8080
        protocol         = "tcp"
        cidr_blocks      = []
        ipv6_cidr_blocks = []
        prefix_list_ids  = []
        security_groups  = ["web-sg"] # Allow access from web servers
        self             = false
        description      = "Allow access from web servers"
      },
      {
        from_port        = 5432
        to_port          = 5432
        protocol         = "tcp"
        cidr_blocks      = []
        ipv6_cidr_blocks = []
        prefix_list_ids  = []
        security_groups  = ["database"] # Allow access from database
        self             = false
        description      = "Allow access from database"
      }
    ]
    egress_rules = [
      {
        from_port        = 0
        to_port          = 0
        protocol         = "-1"
        cidr_blocks      = ["0.0.0.0/0"]
        ipv6_cidr_blocks = []
        prefix_list_ids  = []
        security_groups  = []
        self             = false
        description      = "Allow all outbound traffic"
      }
    ]
    revoke_rules_on_delete = true
    tags = {
      Name        = "BackendSG"
      Environment = "Production"
    }
  },
  "database" = {
    name        = "db-sg"
    name_prefix = "db"
    description = "Security group for database servers"
    vpc_name    = "main" # Replace with the actual VPC ID
    ingress_rules = [
      {
        from_port        = 3306
        to_port          = 3306
        protocol         = "tcp"
        cidr_blocks      = []
        ipv6_cidr_blocks = []
        prefix_list_ids  = []
        security_groups  = ["backend"] # Allow access from backend
        self             = false
        description      = "Allow MySQL access from backend servers"
      }
    ]
    egress_rules = [
      {
        from_port        = 0
        to_port          = 0
        protocol         = "-1"
        cidr_blocks      = ["0.0.0.0/0"]
        ipv6_cidr_blocks = []
        prefix_list_ids  = []
        security_groups  = []
        self             = false
        description      = "Allow all outbound traffic"
      }
    ]
    revoke_rules_on_delete = true
    tags = {
      Name        = "DbSG"
      Environment = "Production"
    }
  }
}
