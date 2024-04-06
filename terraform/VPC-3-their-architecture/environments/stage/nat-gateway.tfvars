nat_gateways = {
  backend1 = {
    vpc        = "tersu"
    elastic_ip = "backend1-nat"
    subnet     = "frontend1"
    tags = {
      Name        = "Backend NAT 1"
      Environment = "stage"
      Owner       = "Tersu"
    }
  },
  backend2 = {
    vpc        = "tersu"
    elastic_ip = "backend2-nat"
    subnet     = "frontend2"
    tags = {
      Name        = "Backend NAT 2"
      Environment = "prod"
      Owner       = "Tersu"
    }
  }
}