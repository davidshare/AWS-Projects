# Cluster Security groups
resource "aws_security_group" "eks_cluster" {
  name        = "earna-${var.environment}/EKSControlPlaneSecurityGroup"
  description = "Communication between the control plane and worker nodegroups"
  vpc_id      = aws_vpc.vpcs["main-${var.environment}"].id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "earna-${var.environment}/EKSControlPlaneSecurityGroup"
    Environment = var.environment
    Owner       = "earna"
  }
}

resource "aws_security_group_rule" "cluster_inbound" {
  description              = "Allow unmanaged nodes to communicate with control plane (all ports)"
  from_port                = 0
  protocol                 = "-1"
  security_group_id        = aws_eks_cluster.eks_clusters["earna-${var.environment}"].vpc_config[0].cluster_security_group_id
  source_security_group_id = aws_security_group.eks_nodes.id
  to_port                  = 0
  type                     = "ingress"
}

# Nodes security group
resource "aws_security_group" "eks_nodes" {
  name        = "earna-${var.environment}/ClusterSharedNodeSecurityGroup"
  description = "Communication between all nodes in the cluster"
  vpc_id      = aws_vpc.vpcs["main-${var.environment}"].id

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    self        = true
  }

  ingress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    security_groups = [aws_eks_cluster.eks_clusters["earna-${var.environment}"].vpc_config[0].cluster_security_group_id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "earna-${var.environment}/ClusterSharedNodeSecurityGroup"
    Environment = var.environment
  }
}