nat_gateways = {
  private1-prod = {
    vpc       = "main-prod"
    elastic_ip = "private1-prod"
    subnet     = "public1-prod"
    tags = {
      Name        = "private1-prod"
      Environment = "prod"
      Owner = "Tersu"
    }
  }
}