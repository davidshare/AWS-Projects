elastic_ips = {
  private1-app-nat = {
    domain = "vpc",
    tags = {
      Name = "private1-app",
      Environment = "prod",
      Owner = "Tersu"
    }
  },

  private2-app-nat = {
    domain = "vpc",
    tags = {
      Name = "private2-app",
      Environment = "prod",
      Owner = "Tersu"
    }
  }
}