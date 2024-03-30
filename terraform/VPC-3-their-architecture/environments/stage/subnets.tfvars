aws_subnets = {
  public1-stage = {
    vpc  = "main-stage"
    cidr_block = "10.1.1.0/24",
    availability_zone = "eu-north-1a",
    map_public_ip_on_launch = true,

    tags = {
      Name = "Public Subnet 1 stage"
      Environment = "stage"
      Owner = "Earna"
      "kubernetes.io/cluster/earna-stage" = "owned"
      "kubernetes.io/role/internal-elb" = "1"
      "kubernetes.io/service-name" = "ingress-nginx/ingress-nginx-controller"
    }
  },
  private1-stage = {
    vpc  = "main-stage"
    cidr_block = "10.1.2.0/24",
    availability_zone = "eu-north-1a",
    map_public_ip_on_launch = false,

    tags = {
      Name = "Private Subnet 1 stage"
      Environment = "stage"
      Owner = "Earna"
      "kubernetes.io/cluster/earna-stage" = "owned"
      "kubernetes.io/role/internal-elb" = "1"
      "kubernetes.io/service-name" = "ingress-nginx/ingress-nginx-controller"
    }
  },
  private2-stage = {
    vpc  = "main-stage"
    cidr_block = "10.1.3.0/24",
    availability_zone = "eu-north-1b",
    map_public_ip_on_launch = false,

    tags = {
      Name = "Private Subnet 2 stage"
      Environment = "stage"
      Owner = "Earna"
      "kubernetes.io/cluster/earna-stage" = "owned"
      "kubernetes.io/role/internal-elb" = "1"
      "kubernetes.io/service-name" = "ingress-nginx/ingress-nginx-controller"
    }
  }
}