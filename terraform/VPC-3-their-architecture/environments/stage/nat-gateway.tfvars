nat_gateways = {
  backend1 = {
    vpc        = "tersu"
    elastic_ip = "backend1-nat"
    subnet     = "frontend1"
    tags = {
      Name        = "Backend NAT 1"
      Description = "Natgateway 1"
    }
  },
  backend2 = {
    vpc        = "tersu"
    elastic_ip = "backend2-nat"
    subnet     = "frontend2"
    tags = {
      Name        = "Backend NAT 2"
      Description = "Natgateway 2"
    }
  }
}