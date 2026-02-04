variable "environment" { type = string }
variable "project_name" { type = string }
variable "streams" {
  type = map(object({
    shard_count      = number
    retention_period = number
  }))
}
