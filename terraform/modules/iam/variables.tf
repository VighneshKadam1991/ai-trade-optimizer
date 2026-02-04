variable "environment" { type = string }
variable "project_name" { type = string }
variable "eks_cluster_name" { type = string }
variable "eks_oidc_provider_arn" { type = string }
variable "s3_bucket_arns" { type = list(string) }
