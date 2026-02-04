data "aws_caller_identity" "current" {}

resource "aws_iam_role" "service_accounts" {
  for_each = toset([
    "order-service",
    "execution-service",
    "analytics-service"
  ])

  name = "${var.project_name}-${var.environment}-${each.value}"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Principal = {
        Federated = var.eks_oidc_provider_arn
      }
      Action = "sts:AssumeRoleWithWebIdentity"
      Condition = {
        StringEquals = {
          "${replace(var.eks_oidc_provider_arn, "/^(.*provider/)/", "")}:sub": "system:serviceaccount:default:${each.value}"
          "${replace(var.eks_oidc_provider_arn, "/^(.*provider/)/", "")}:aud": "sts.amazonaws.com"
        }
      }
    }]
  })
}

resource "aws_iam_role_policy" "s3_access" {
  for_each = aws_iam_role.service_accounts

  name = "s3-access"
  role = each.value.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Action = [
        "s3:GetObject",
        "s3:PutObject",
        "s3:ListBucket"
      ]
      Resource = concat(
        var.s3_bucket_arns,
        [for arn in var.s3_bucket_arns : "${arn}/*"]
      )
    }]
  })
}
