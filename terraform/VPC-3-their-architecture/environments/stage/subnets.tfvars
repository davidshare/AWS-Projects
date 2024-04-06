aws_subnets = {
  frontend1 = {
    vpc                     = "tersu"
    cidr_block              = "10.20.0.0/24"
    availability_zone       = "us-east-1a"
    map_public_ip_on_launch = true
    tags = {
      Name        = "Frontend 1"
      Description = "Tersu Public subnet 1"
    }
  }
  frontend2 = {
    vpc                     = "tersu"
    cidr_block              = "10.20.1.0/24"
    availability_zone       = "us-east-1b"
    map_public_ip_on_launch = true
    tags = {
      Name        = "Frontend 2"
      Description = "Tersu Public subnet 2"
    }
  }
  backend1 = {
    vpc                     = "tersu"
    cidr_block              = "10.20.10.0/24"
    availability_zone       = "us-east-1a"
    map_public_ip_on_launch = false
    tags = {
      Name        = "Backend 1"
      Description = "Tersu Private subnet 1"
    }
  }
  backend2 = {
    vpc                     = "tersu"
    cidr_block              = "10.20.11.0/24"
    availability_zone       = "us-east-1b"
    map_public_ip_on_launch = false
    tags = {
      Name        = "Backend 2"
      Description = "Tersu Private subnet 2"
    }
  }
  database1 = {
    vpc                     = "tersu"
    cidr_block              = "10.20.20.0/24"
    availability_zone       = "us-east-1a"
    map_public_ip_on_launch = false
    tags = {
      Name        = "Database 1"
      Description = "Tersu Database subnet 1"
    }
  }
  database2 = {
    vpc                     = "tersu"
    cidr_block              = "10.20.21.0/24"
    availability_zone       = "us-east-1b"
    map_public_ip_on_launch = false
    tags = {
      Name        = "Database 2"
      Description = "Tersu Database subnet 2"
    }
  }
}