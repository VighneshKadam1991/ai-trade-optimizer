variable "region" {
  default = "eu-west-2"
}

variable "service_image_map" {
  type = map(string)
  default = {
    execution-agent = "REPLACE_ME"
  }
}