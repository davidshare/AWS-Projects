elastic_ips = {
  backend1-nat = {
    domain = "vpc",
    tags = {
      Name        = "Backend1",
      Description = "Elastic IP for natgateway 1"
    }
  },

  backend2-nat = {
    domain = "vpc",
    tags = {
      Name        = "Backend2",
      Description = "Elastic IP for natgateway 2"
    }
  }
}