aws_vpcs = {
  tersu = {
    cidr                 = "10.20.0.0/16"
    tenancy              = "default"
    enable_dns_hostnames = true
    enable_dns_support   = true
    tags = {
      Name        = "Tersu Main"
      Description = "Tersu Main VPC"
    }
  }
}