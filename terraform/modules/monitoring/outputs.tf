output "log_groups" {
  value = merge(
    { cluster = aws_cloudwatch_log_group.eks.name },
    { for k, v in aws_cloudwatch_log_group.services : k => v.name }
  )
}
