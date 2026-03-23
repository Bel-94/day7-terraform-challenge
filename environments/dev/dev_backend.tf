# Key path: environments/dev/terraform.tfstate, a change in this directory can NEVER affect staging
# or production state — different files, different locks.

terraform {
  backend "s3" {
    bucket         = "belinda-terraform-state-30daychallenge"
    key            = "environments/dev/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "terraform-state-locks"
    encrypt        = true
  }
}
