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

variable "instance_type" {
  description = "EC2 instance type for this environment"
  type        = string
  default     = "t2.micro"
}

variable "environment" {
  description = "Environment name — used in resource names and tags"
  type        = string
  default     = "dev"
}

variable "project_name" {
  description = "Project name for tagging"
  type        = string
  default     = "30-Day Terraform Challenge"
}

variable "owner" {
  description = "Owner name for resource tags"
  type        = string
  default     = "Belinda Ntinyari"
}
