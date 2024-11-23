vpcs = {
  "main" = {
    cidr_block                       = "10.0.0.0/16"
    enable_dns_hostnames             = true
    assign_generated_ipv6_cidr_block = true
    tags = {
      Name = "MyVPC"
    }
  },
  "secondary" = {
    cidr_block                       = "10.1.0.0/16"
    enable_dns_hostnames             = false
    assign_generated_ipv6_cidr_block = true
    tags = {
      Name = "SecondaryVPC"
    }
  }
}
