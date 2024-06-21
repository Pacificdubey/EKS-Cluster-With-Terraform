output "cluster_id" {
  value = aws_eks_cluster.eks.id
}

output "cluster_endpoint" {
  value = aws_eks_cluster.eks.endpoint
}

output "cluster_arn" {
  value = aws_eks_cluster.eks.arn
}

output "cluster_version" {
  value = aws_eks_cluster.eks.version
}

output "oidc_provider_arn" {
  value = aws_iam_openid_connect_provider.oidc_provider.arn
}

output "cluster_name" {
  value = aws_eks_cluster.eks.name
}