internet_gateways = {
  main = {
    name = "main-prod"
    vpc       = "main-prod"
    tags = {
      Name        = "main-prod"
      Environment = "prod"
      Owner = "Tersu"
    }
  }
}