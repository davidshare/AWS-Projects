aws_vpcs = {
  main-prod = {
    cidr = "10.0.0.0/16"
    tenancy = "default"
    enable_dns_hostnames = true
    enable_dns_support = true
    tags = {
      Name = "earna prod"
      Description = "Earna main Main VPC"
      Owner = "Earna"
      Environment = "prod"
    }
  }
}