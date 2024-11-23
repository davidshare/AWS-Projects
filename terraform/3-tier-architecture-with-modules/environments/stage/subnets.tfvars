subnets = {
  "primary_public_1" = {
    cidr_block        = "10.0.1.0/24"
    availability_zone = "us-east-1a"
    public            = true
    vpc_name          = "main"
    tags = {
      Name = "PrimaryPublicSubnet1"
    }
  },
  "primary_public_2" = {
    cidr_block        = "10.0.2.0/24"
    availability_zone = "us-east-1b"
    public            = true
    vpc_name          = "main"
    tags = {
      Name = "PrimaryPublicSubnet2"
    }
  },
  "primary_backend_private_1" = {
    cidr_block        = "10.0.3.0/24"
    availability_zone = "us-east-1a"
    public            = false
    vpc_name          = "main"
    tags = {
      Name = "PrimaryBackendPrivateSubnet1"
    }
  },
  "primary_backend_private_2" = {
    cidr_block        = "10.0.4.0/24"
    availability_zone = "us-east-1b"
    public            = false
    vpc_name          = "main"
    tags = {
      Name = "PrimaryBackendPrivateSubnet2"
    }
  },
  "primary_db_private_1" = {
    cidr_block        = "10.0.5.0/24"
    availability_zone = "us-east-1a"
    public            = false
    vpc_name          = "main"
    tags = {
      Name = "PrimaryDBPrivateSubnet1"
    }
  },
  "primary_db_private_2" = {
    cidr_block        = "10.0.6.0/24"
    availability_zone = "us-east-1b"
    public            = false
    vpc_name          = "main"
    tags = {
      Name = "PrimaryDBPrivateSubnet2"
    }
  }
}
