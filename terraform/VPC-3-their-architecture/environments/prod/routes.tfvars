route_tables = {
  "public-prod" = {
    vpc = "main-prod"
    tags = {
      Name = "public-prod"
      Owner = "Earna"
    }
  },
  "private-prod" = {
    vpc = "main-prod"
    tags = {
      Name = "private-prod"
      Owner = "Earna"
    }
  }
}

internet_gateway_routes = {
  public1-prod = {
    route_table = "public-prod"
    cidr        = "0.0.0.0/0"
    gateway     = "main"
  }
}

nat_gateway_routes = {
  private1-prod = {
    route_table = "private-prod"
    cidr        = "0.0.0.0/0"
    gateway     = "main"
  },
}

subnets_route_table_association = {
  public1-prod = {
    route_table = "public-prod"
    subnet      = "public1-prod"
  },
  private1 = {
    route_table = "private-prod"
    subnet      = "private1-prod"
  },
  private2 = {
    route_table = "private-prod"
    subnet      = "private2-prod"
  },
}