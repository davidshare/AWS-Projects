aws_vpcs = {
  main-stage = {
    cidr = "10.1.0.0/16"
    tenancy = "default"
    enable_dns_hostnames = true
    enable_dns_support = true
    tags = {
      Name = "earna stage"
      Description = "Earna main Main VPC"
      Owner = "Earna"
      Environment = "stage"
    }
  }
}