data "aws_iam_policy_document" "eks_ebs_assume_role_policy" {
  statement {
    actions = ["sts:AssumeRoleWithWebIdentity"]
    effect  = "Allow"

    condition {
      test     = "StringEquals"
      variable = "${replace(aws_iam_openid_connect_provider.oidc_provider.url, "https://", "")}:sub"
      values   = ["system:serviceaccount:kube-system:ebs-csi-controller-sa"]
    }

    principals {
      identifiers = [aws_iam_openid_connect_provider.oidc_provider.arn]
      type        = "Federated"
    }
  }
}

resource "aws_iam_role" "eks_cluster_ebs" {
  assume_role_policy = data.aws_iam_policy_document.eks_ebs_assume_role_policy.json
  name               = "eks_cluster_ebs"
}

resource "aws_iam_policy" "eks_ebs_policy" {
  name = "eks_ebs_policy"

  policy = jsonencode({
    Statement = [{
      Action = [
                "ec2:CreateSnapshot",
                "ec2:CreateVolume",
                "ec2:AttachVolume",
                "ec2:DetachVolume",
                "ec2:ModifyVolume",
                "ec2:CreateTags",
                "ec2:DescribeAvailabilityZones",
                "ec2:DescribeInstances",
                "ec2:DescribeSnapshots",
                "ec2:DescribeTags",
                "ec2:DescribeVolumes",
                "ec2:DescribeVolumesModifications"
            ]
      Effect   = "Allow"
      Resource = "*"
    }]
    Version = "2012-10-17"
  })
}

resource "aws_iam_role_policy_attachment" "eks_ebs_attach" {
  role       = aws_iam_role.eks_cluster_ebs.name
  policy_arn = aws_iam_policy.eks_ebs_policy.arn
}

output "eks_cluster_ebs_arn" {
  value = aws_iam_role.eks_cluster_ebs.arn
}