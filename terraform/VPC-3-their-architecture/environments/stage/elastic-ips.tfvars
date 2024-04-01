elastic_ips = {
  private1-nat = {
    domain = "vpc",
    tags = {
      Name = "private1-app",
      Environment = "stage",
      Owner = "Tersu"
    }
  },
  private2-nat = {
    domain = "vpc",
    tags = {
      Name = "private2-app",
      Environment = "stage",
      Owner = "Tersu"
    }
  }
}