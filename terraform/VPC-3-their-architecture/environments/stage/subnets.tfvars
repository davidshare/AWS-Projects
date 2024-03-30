aws_subnets = {
  public1-web = {
    vpc                     = "main"
    cidr_block              = "10.20.0.0/24"
    availability_zone       = "eu-north-1a"
    map_public_ip_on_launch = true
    tags = {
      Name = "Public Subnet 1 Web"
      Owner = "Tersu"
    }
  }
  public2-web = {
    vpc                     = "main"
    cidr_block              = "10.20.1.0/24"
    availability_zone       = "eu-north-1b"
    map_public_ip_on_launch = true
    tags = {
      Name = "Public Subnet 2 Web"
      Owner = "Tersu"
    }
  }
  private1-app = {
    vpc                     = "main"
    cidr_block              = "10.20.10.0/24"
    availability_zone       = "eu-north-1a"
    map_public_ip_on_launch = false
    tags = {
      Name = "Private Subnet 1 App"
      Owner = "Tersu"
    }
  }
  private2-app = {
    vpc                     = "main"
    cidr_block              = "10.20.11.0/24"
    availability_zone       = "eu-north-1b"
    map_public_ip_on_launch = false
    tags = {
      Name = "Private Subnet 2 App"
      Owner = "Tersu"
    }
  }
  private1-db = {
    vpc                     = "main"
    cidr_block              = "10.20.20.0/24"
    availability_zone       = "eu-north-1a"
    map_public_ip_on_launch = false
    tags = {
      Name = "Private Subnet 1 DB"
      Owner = "Tersu"
    }
  }
  private2-db = {
    vpc                     = "main"
    cidr_block              = "10.20.21.0/24"
    availability_zone       = "eu-north-1b"
    map_public_ip_on_launch = false
    tags = {
      Name = "Private Subnet 2 DB"
      Owner = "Tersu"
    }
  }
}