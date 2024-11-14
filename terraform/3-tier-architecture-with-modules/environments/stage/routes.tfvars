route_tables = {
  "primary_public" = {
    vpc = "main"
    tags = {
      Name        = "Frontend"
      Description = "route table for the public subnets"
    }
  },
  "primary_backend_private" = {
    vpc = "main"
    tags = {
      Name        = "Backend in AZ A"
      Description = "route table for the private subnets in one AZ A"
    }
  },
  "primary_db_private" = {
    vpc = "main"
    tags = {
      Name        = "Backend in AZ B"
      Description = "route table for the private subnets in one AZ B"
    }
  }
}

subnets_route_table_association = {
  primary_public_1 = {
    route_table = "primary_public"
    subnet      = "primary_public_1"
  },
  primary_public_2 = {
    route_table = "primary_public"
    subnet      = "primary_public_2"
  },
  primary_backend_private_1 = {
    route_table = "primary_backend_private"
    subnet      = "primary_backend_private_1"
  },
  primary_backend_private_2 = {
    route_table = "primary_backend_private"
    subnet      = "primary_backend_private_2"
  },
  primary_db_private_1 = {
    route_table = "primary_db_private"
    subnet      = "primary_db_private_1"
  },
  primary_db_private_2 = {
    route_table = "primary_db_private"
    subnet      = "primary_db_private_2"
  },
}

internet_gateway_routes = {
  public-web = {
    route_table = "primary_public"
    cidr        = "0.0.0.0/0"
    gateway     = "main"
  }
}

nat_gateway_routes = {
  primary_backend_private_1 = {
    route_table = "primary_backend_private"
    cidr        = "0.0.0.0/0"
    gateway     = "primary_backend_private_1"
  },
  primary_backend_private_2 = {
    route_table = "primary_db_private"
    cidr        = "0.0.0.0/0"
    gateway     = "primary_backend_private_2"
  },
}