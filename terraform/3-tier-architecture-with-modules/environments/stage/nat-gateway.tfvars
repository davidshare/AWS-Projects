nat_gateways = {
  primary_backend_private_1 = {
    vpc        = "main"
    elastic_ip = "primary_backend_private_1"
    subnet     = "primary_public_1"
    tags = {
      Name        = "Backend NAT 1"
      Description = "Natgateway 1"
    }
  },
  primary_backend_private_2 = {
    vpc        = "main"
    elastic_ip = "primary_backend_private_2"
    subnet     = "primary_public_2"
    tags = {
      Name        = "Backend NAT 2"
      Description = "Natgateway 2"
    }
  }
}