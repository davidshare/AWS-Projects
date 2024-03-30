route_tables = {
  "public-stage" = {
    vpc = "main-stage"
    tags = {
      Name = "public-stage"
      Owner = "Tersu"
    }
  },
  "private-stage" = {
    vpc = "main-stage"
    tags = {
      Name = "private-stage"
      Owner = "Tersu"
    }
  }
}

internet_gateway_routes = {
  public1-stage = {
    route_table = "public-stage"
    cidr        = "0.0.0.0/0"
    gateway     = "main"
  }
}

nat_gateway_routes = {
  private1-stage = {
    route_table = "private-stage"
    cidr        = "0.0.0.0/0"
    gateway     = "main"
  },
}

subnets_route_table_association = {
  public1-stage = {
    route_table = "public-stage"
    subnet      = "public1-stage"
  },
  private1-stage = {
    route_table = "private-stage"
    subnet      = "private1-stage"
  },
  private2-stage = {
    route_table = "private-stage"
    subnet      = "private2-stage"
  },
}