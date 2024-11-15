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
  }
}
