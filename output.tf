output "cluster_id" {
  value = module.eks.cluster_id
}

output "cluster_endpoint" {
  value = module.eks.cluster_endpoint
}

output "cluster_arn" {
  value = module.eks.cluster_arn
}

output "cluster_version" {
  value = module.eks.cluster_version
}


# S3 access arn
output "S3-access_arn" {
  value = module.eks.test_policy_arn
}


# Autoscalar-arn
output "AutoScalar-arn" {
    value = module.eks.eks_cluster_autoscaler_arn
}

# EBS -role arn
output "eks_cluster_ebs_arn" {
  value = module.eks.eks_cluster_ebs_arn
}
