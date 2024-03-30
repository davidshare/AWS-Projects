output "tersu-eks-endpoint" {
    value = aws_eks_cluster.eks_clusters["tersu-${var.environment}"].endpoint
}

output "kubeconfig-certificate-authority-data" {
    value = aws_eks_cluster.eks_clusters["tersu-${var.environment}"].certificate_authority[0].data
}