terraform {
  backend "s3" {
    bucket         = "quant-terraform-state-main"
    key            = "execution-platform/terraform.tfstate"
    region         = "eu-west-2"
    dynamodb_table = "terraform-locks"
    encrypt        = true
  }
}
