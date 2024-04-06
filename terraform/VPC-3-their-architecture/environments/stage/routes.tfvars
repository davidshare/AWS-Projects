route_tables = {
  "frontend" = {
    vpc = "tersu"
    tags = {
      Name  = "Frontend"
      Description = "route table for the public subnets"
    }
  },
  "backend" = {
    vpc = "tersu"
    tags = {
      Name  = "Backend"
      Description = "route table for the private subnets"
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
    route_table = "backend"
    subnet      = "backend1"
  },
  backend2 = {
    route_table = "backend"
    subnet      = "backend2"
  },
  database1 = {
    route_table = "database"
    subnet      = "database1"
  },
  database2 = {
    route_table = "database"
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
    route_table = "backend"
    cidr        = "0.0.0.0/0"
    gateway     = "main"
  },
  backend2 = {
    route_table = "backend"
    cidr        = "0.0.0.0/0"
    gateway     = "main"
  },
}