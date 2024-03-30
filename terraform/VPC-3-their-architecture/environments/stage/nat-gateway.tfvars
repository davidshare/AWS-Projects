nat_gateways = {
  private1-stage = {
    vpc       = "main-stage"
    elastic_ip = "private1-stage"
    subnet     = "public1-stage"
    tags = {
      Name        = "private1-stage"
      Environment = "stage"
      Owner = "Earna"
    }
  }
}