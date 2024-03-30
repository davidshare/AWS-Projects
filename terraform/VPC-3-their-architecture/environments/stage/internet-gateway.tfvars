internet_gateways = {
  main = {
    name = "main"
    vpc       = "main-stage"
    tags = {
      Name        = "main-stage"
      Environment = "stage"
      Owner = "Earna"
    }
  }
}