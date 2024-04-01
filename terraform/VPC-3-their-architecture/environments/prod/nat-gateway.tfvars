nat_gateways = {
  private1-app = {
    vpc       = "main"
    elastic_ip = "private1-nat"
    subnet     = "public1-web"
    tags = {
      Name        = "Private NAT 1 App"
      Environment = "prod"
      Owner = "Tersu"
    }
  },
  private2-app = {
    vpc       = "main"
    elastic_ip = "private2-nat"
    subnet     = "public2-web"
    tags = {
      Name        = "Private NAT 2 App"
      Environment = "prod"
      Owner = "Tersu"
    }
  }
}