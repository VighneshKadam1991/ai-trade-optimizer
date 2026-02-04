# This file configures Terraform to use S3 for remote state storage
# The backend is created automatically by GitHub Actions

terraform {
  backend "s3" {
    # These values are provided via -backend-config flags in GitHub Actions
    # bucket         = "trading-platform-terraform-state"
    # key            = "terraform.tfstate"
    # region         = "us-east-1"
    # dynamodb_table = "terraform-state-lock"
    # encrypt        = true
  }
}
