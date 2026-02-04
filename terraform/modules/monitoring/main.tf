resource "aws_cloudwatch_log_group" "eks" {
  name              = "/aws/eks/${var.cluster_name}/cluster"
  retention_in_days = var.log_retention_days
}

resource "aws_cloudwatch_log_group" "services" {
  for_each = toset([
    "order-service",
    "execution-service",
    "analytics-service"
  ])

  name              = "/aws/eks/${var.cluster_name}/${each.value}"
  retention_in_days = var.log_retention_days
}
