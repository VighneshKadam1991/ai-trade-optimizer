variable "environment" { type = string }
variable "project_name" { type = string }
variable "buckets" {
  type = map(object({
    versioning_enabled = bool
    lifecycle_rules    = list(object({
      id              = string
      enabled         = bool
      transition_days = number
      storage_class   = string
    }))
  }))
}
