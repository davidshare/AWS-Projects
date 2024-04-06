route_tables = {
  "frontend" = {
    vpc = "tersu"
    tags = {
      Name        = "Frontend"
      Description = "route table for the public subnets"
    }
  },
  "backend_a" = {
    vpc = "tersu"
    tags = {
      Name        = "Backend in AZ A"
      Description = "route table for the private subnets in one AZ A"
    }
  },
  "backend_b" = {
    vpc = "tersu"
    tags = {
      Name        = "Backend in AZ B"
      Description = "route table for the private subnets in one AZ B"
    }
  }
}

subnets_route_table_association = {
  frontend1 = {
    route_table = "frontend"
    subnet      = "frontend1"
  },
  frontend2 = {
    route_table = "frontend"
    subnet      = "frontend2"
  },
  backend1 = {
    route_table = "backend_a"
    subnet      = "backend1"
  },
  backend2 = {
    route_table = "backend_b"
    subnet      = "backend2"
  },
  database1 = {
    route_table = "backend_a"
    subnet      = "database1"
  },
  database2 = {
    route_table = "backend_b"
    subnet      = "database2"
  },
}

internet_gateway_routes = {
  public-web = {
    route_table = "frontend"
    cidr        = "0.0.0.0/0"
    gateway     = "tersu"
  }
}

nat_gateway_routes = {
  backend1 = {
    route_table = "backend_a"
    cidr        = "0.0.0.0/0"
    gateway     = "tersu"
  },
  backend2 = {
    route_table = "backend_b"
    cidr        = "0.0.0.0/0"
    gateway     = "tersu"
  },
}