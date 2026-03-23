variable "aws_region" {
  description = "AWS region to deploy resources into"
  type        = string
  default     = "us-east-1"
}

variable "ami_id" {
  description = "Amazon Linux 2 AMI for us-east-1"
  type        = string
  default     = "ami-0c02fb55956c7d316"
}

# instance_type is a map keyed by workspace name, terraform.workspace returns the active workspace name
# var.instance_type[terraform.workspace] gives the right size for each environment automatically.
# dev - t2.micro  (cheapest, Free Tier eligible), staging - t2.small  (slightly larger for closer-to-prod testing), production - t2.medium (production-grade) 

variable "instance_type" {
  description = "EC2 instance type per environment"
  type        = map(string)
  default = {
    dev        = "t2.micro"
    staging    = "t2.small"
    production = "t2.medium"
  }
}

variable "project_name" {
  description = "Project name used for tagging resources"
  type        = string
  default     = "30-Day Terraform Challenge"
}

variable "owner" {
  description = "Owner name for resource tags"
  type        = string
  default     = "Belinda Ntinyari"
}
