aws_subnets = {
  public1-prod = {
    vpc  = "main-prod"
    cidr_block = "10.0.1.0/24",
    availability_zone = "eu-north-1a",
    map_public_ip_on_launch = true,

    tags = {
      Name = "Public Subnet 1 prod"
      Environment = "prod"
      Owner = "Tersu"
      "kubernetes.io/cluster/tersu-prod" = "owned"
      "kubernetes.io/role/internal-elb" = "1"
      "kubernetes.io/service-name" = "ingress-nginx/ingress-nginx-controller"
    }
  },
  private1-prod = {
    vpc  = "main-prod"
    cidr_block = "10.0.2.0/24",
    availability_zone = "eu-north-1a",
    map_public_ip_on_launch = false,

    tags = {
      Name = "Private Subnet 1 prod"
      Environment = "prod"
      Owner = "Tersu"
      "kubernetes.io/cluster/tersu-prod" = "owned"
      "kubernetes.io/role/internal-elb" = "1"
      "kubernetes.io/service-name" = "ingress-nginx/ingress-nginx-controller"

    }
  },
  private2-prod = {
    vpc  = "main-prod"
    cidr_block = "10.0.3.0/24",
    availability_zone = "eu-north-1b",
    map_public_ip_on_launch = false,

    tags = {
      Name = "Private Subnet 2 prod"
      Environment = "prod"
      Owner = "Tersu"
      "kubernetes.io/cluster/tersu-prod" = "owned"
      "kubernetes.io/role/internal-elb" = "1"
      "kubernetes.io/service-name" = "ingress-nginx/ingress-nginx-controller"
    }
  }
}