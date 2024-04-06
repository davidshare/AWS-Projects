elastic_ips = {
  backend1-nat = {
    domain = "vpc",
    tags = {
      Name        = "Backend1",
      Environment = "prod",
      Owner       = "Tersu"
    }
  },

  backend2-nat = {
    domain = "vpc",
    tags = {
      Name        = "Backend2",
      Environment = "prod",
      Owner       = "Tersu"
    }
  }
}