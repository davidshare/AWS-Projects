elastic_ips = {
  primary_backend_private_1 = {
    domain = "vpc",
    tags = {
      Name        = "NAT gateway 1",
      Description = "Elastic IP for natgateway 1"
    }
  },

  primary_backend_private_2 = {
    domain = "vpc",
    tags = {
      Name        = "NAT gateway 2",
      Description = "Elastic IP for natgateway 2"
    }
  }
}