output "earna-eks-endpoint" {
    value = aws_eks_cluster.eks_clusters["earna-${var.environment}"].endpoint
}

output "kubeconfig-certificate-authority-data" {
    value = aws_eks_cluster.eks_clusters["earna-${var.environment}"].certificate_authority[0].data
}