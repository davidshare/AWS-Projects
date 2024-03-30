aws_vpcs = {
  main-stage = {
    cidr = "10.1.0.0/16"
    tenancy = "default"
    enable_dns_hostnames = true
    enable_dns_support = true
    tags = {
      Name = "tersu stage"
      Description = "Tersu main Main VPC"
      Owner = "Tersu"
      Environment = "stage"
    }
  }
}