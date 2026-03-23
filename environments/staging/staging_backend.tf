# Key path: environments/staging/terraform.tfstate

terraform {
  backend "s3" {
    bucket         = "belinda-terraform-state-30daychallenge"
    key            = "environments/staging/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "terraform-state-locks"
    encrypt        = true
  }
}
