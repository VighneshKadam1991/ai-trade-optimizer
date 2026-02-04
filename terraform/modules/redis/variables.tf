variable "environment" { type = string }
variable "cluster_id" { type = string }
variable "vpc_id" { type = string }
variable "subnet_ids" { type = list(string) }
variable "node_type" { type = string }
variable "num_cache_nodes" { type = number }
variable "engine_version" { type = string }
variable "allowed_security_group_ids" { type = list(string) }
