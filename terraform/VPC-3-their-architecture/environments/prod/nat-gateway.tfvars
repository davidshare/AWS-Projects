nat_gateways = {
  private1-nat = {
    vpc       = "main"
    elastic_ip = "private1-nat"
    subnet     = "public1-web"
    tags = {
      Name        = "Private NAT 1"
      Environment = "prod"
      Owner = "Tersu"
    }
  },
  private2-nat = {
    vpc       = "main"
    elastic_ip = "private2-nat"
    subnet     = "public2-web"
    tags = {
      Name        = "Private NAT 2"
      Environment = "prod"
      Owner = "Tersu"
    }
  }
}