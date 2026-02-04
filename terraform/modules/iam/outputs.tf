output "service_account_roles" {
  value = { for k, v in aws_iam_role.service_accounts : k => v.arn }
}
