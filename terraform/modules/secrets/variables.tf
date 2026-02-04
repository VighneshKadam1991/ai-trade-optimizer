variable "environment" { type = string }
variable "project_name" { type = string }
variable "secrets" {
  type = map(object({
    description   = string
    secret_string = string
  }))
  sensitive = true
}
