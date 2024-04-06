route_tables = {
  "public-web" = {
    vpc = "main"
    tags = {
      Name  = "public-web"
      Owner = "Tersu"
    }
  },
  "private-app" = {
    vpc = "main"
    tags = {
      Name  = "private-app"
      Owner = "Tersu"
    }
  }
}

subnets_route_table_association = {
  public1-web = {
    route_table = "public-web"
    subnet      = "public1-web"
  },
  public2-web = {
    route_table = "public-web"
    subnet      = "public2-web"
  },
  private1-app = {
    route_table = "private-app"
    subnet      = "private1-app"
  },
  private2-app = {
    route_table = "private-app"
    subnet      = "private2-app"
  },
  private1-db = {
    route_table = "private-app"
    subnet      = "private1-db"
  },
  private2-db = {
    route_table = "private-app"
    subnet      = "private2-db"
  },
}

internet_gateway_routes = {
  public-web = {
    route_table = "public-web"
    cidr        = "0.0.0.0/0"
    gateway     = "main"
  }
}

nat_gateway_routes = {
  private1-nat = {
    route_table = "private-app"
    cidr        = "0.0.0.0/0"
    gateway     = "main"
  },
  private2-nat = {
    route_table = "private-app"
    cidr        = "0.0.0.0/0"
    gateway     = "main"
  },
}