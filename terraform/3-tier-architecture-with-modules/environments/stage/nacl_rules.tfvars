network_acl_rules = {
  # Web Tier NACL Rules
  web_primary_http = {
    network_acl = "primary_public"
    rule_number = 100
    protocol    = "tcp"
    from_port   = 80
    to_port     = 80
    cidr_block  = "0.0.0.0/0" # Allow HTTP from anywhere
    egress      = false
    rule_action = "allow"
  },
  web_primary_https = {
    network_acl = "primary_public"
    rule_number = 110
    protocol    = "tcp"
    from_port   = 443
    to_port     = 443
    cidr_block  = "0.0.0.0/0" # Allow HTTPS from anywhere
    rule_action = "allow"
    egress      = false
  },
  web_primary_to_backend = {
    network_acl = "primary_public"
    rule_number = 120
    protocol    = "tcp"
    from_port   = 8080
    to_port     = 8080
    cidr_block  = "0.0.0.0/0"
    rule_action = "allow"
    egress      = false
  },
  web_outbound_to_backend = {
    network_acl = "primary_public"
    rule_number = 200
    protocol    = "tcp"
    from_port   = 1024
    to_port     = 65535
    cidr_block  = "10.0.3.0/24" # Backend subnet CIDR blocks
    rule_action = "allow"
    egress      = true
  },
  web_outbound_to_backend_2 = {
    network_acl = "primary_public"
    rule_number = 201
    protocol    = "tcp"
    from_port   = 1024
    to_port     = 65535
    cidr_block  = "10.0.4.0/24" # Backend subnet CIDR blocks
    rule_action = "allow"
    egress      = true
  },

  # Backend Tier NACL Rules
  backend_primary_from_web = {
    network_acl = "primary_backend_private"
    rule_number = 100
    protocol    = "tcp"
    from_port   = 8080
    to_port     = 8080
    cidr_block  = "0.0.0.0/0"
    rule_action = "allow"
    egress      = false
  },
  backend_primary_to_database = {
    network_acl = "primary_backend_private"
    rule_number = 110
    protocol    = "tcp"
    from_port   = 3306 # MySQL port or 5432 for PostgreSQL
    to_port     = 3306
    cidr_block  = "0.0.0.0/0"
    rule_action = "allow"
    egress      = false
  },
  backend_outbound_to_web = {
    network_acl = "primary_backend_private"
    rule_number = 200
    protocol    = "tcp"
    from_port   = 8080
    to_port     = 8080
    cidr_block  = "10.0.1.0/24" # Web subnet CIDR blocks
    rule_action = "allow"
    egress      = true
  },
  backend_outbound_to_web_2 = {
    network_acl = "primary_backend_private"
    rule_number = 201
    protocol    = "tcp"
    from_port   = 8080
    to_port     = 8080
    cidr_block  = "10.0.2.0/24" # Web subnet CIDR blocks
    rule_action = "allow"
    egress      = true
  },

  # Database Tier NACL Rules
  database_primary_from_backend = {
    network_acl = "primary_db_private"
    rule_number = 100
    protocol    = "tcp"
    from_port   = 3306 # MySQL port or 5432 for PostgreSQL
    to_port     = 3306
    cidr_block  = "0.0.0.0/0"
    rule_action = "allow"
    egress      = false
  },
  database_outbound_to_backend = {
    network_acl = "primary_db_private"
    rule_number = 201
    protocol    = "tcp"
    from_port   = 1024
    to_port     = 65535
    cidr_block  = "10.0.3.0/24" # Backend subnet CIDR blocks
    rule_action = "allow"
    egress      = true
  },
  database_outbound_to_backend_2 = {
    network_acl = "primary_db_private"
    rule_number = 200
    protocol    = "tcp"
    from_port   = 1024
    to_port     = 65535
    cidr_block  = "10.0.4.0/24" # Backend subnet CIDR blocks
    rule_action = "allow"
    egress      = true
  }
}
