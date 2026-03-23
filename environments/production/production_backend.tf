# Key path: environments/production/terraform.tfstate
# Production state is completely isolate, changes here can never affect dev or staging.

terraform {
  backend "s3" {
    bucket         = "belinda-terraform-state-30daychallenge"
    key            = "environments/production/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "terraform-state-locks"
    encrypt        = true
  }
}
