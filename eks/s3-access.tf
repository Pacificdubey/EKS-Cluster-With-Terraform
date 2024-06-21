data "aws_iam_policy_document" "workload-policy-document" {
  statement {
    actions = ["sts:AssumeRoleWithWebIdentity"]
    effect  = "Allow"

    condition {
      test     = "StringEquals"
      variable = "${replace(aws_iam_openid_connect_provider.oidc_provider.url, "https://", "")}:sub"
      values   = ["system:serviceaccount:default:workload-sa"]
    }

    principals {
      identifiers = [aws_iam_openid_connect_provider.oidc_provider.arn]
      type        = "Federated"
    }
  }
}

resource "aws_iam_role" "workload-role" {
  assume_role_policy = data.aws_iam_policy_document.workload-policy-document.json
  name               = "workload-role"
}

resource "aws_iam_policy" "s3-policy" {
  name = "s3-policy"

  policy = jsonencode({
    Statement = [{
      Action = [
        "s3:ListAllMyBuckets",
        "s3:GetBucketLocation"
      ]
      Effect   = "Allow"
      Resource = "arn:aws:s3:::*"
    }]
    Version = "2012-10-17"
  })
}

resource "aws_iam_role_policy_attachment" "test_attach" {
  role       = aws_iam_role.workload-role.name
  policy_arn = aws_iam_policy.s3-policy.arn
}

output "test_policy_arn" {
  value = aws_iam_role.workload-role.arn
}
