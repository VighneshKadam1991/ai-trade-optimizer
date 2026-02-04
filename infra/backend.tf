terraform {
  backend "s3" {
    bucket         = "agentic-trading-tf-state"
    key            = "test/infra.tfstate"
    region         = "eu-west-1"
    dynamodb_table = "terraform-locks"
    encrypt        = true
  }
}
