# Demonstrates the terraform_remote_state data source.


provider "aws" {
  region = var.aws_region
}

# Remote State Data Source, reads outputs from the dev environment's state file.

data "terraform_remote_state" "dev" {
  backend = "s3"
  config = {
    bucket = "belinda-terraform-state-30daychallenge"
    key    = "environments/dev/terraform.tfstate"
    region = "us-east-1"
  }
}

resource "aws_security_group" "web_sg" {
  name        = "belinda-web-sg-${var.environment}"
  description = "Web server SG for ${var.environment} environment"

  ingress {
    description = "Allow HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "belinda-web-sg-${var.environment}"
    Environment = var.environment
    Project     = var.project_name
    Owner       = var.owner
  }
}

# EC2 Instance

resource "aws_instance" "web" {
  ami                    = var.ami_id
  instance_type          = var.instance_type
  vpc_security_group_ids = [aws_security_group.web_sg.id]
  subnet_id              = data.terraform_remote_state.dev.outputs.subnet_id

  user_data = <<-EOF
              #!/bin/bash
              yum update -y
              yum install -y httpd
              systemctl start httpd
              systemctl enable httpd
              echo "<h1>Environment: ${var.environment}</h1><p>Belinda Ntinyari — Day 7 Terraform Challenge</p>" > /var/www/html/index.html
              EOF

  tags = {
    Name        = "belinda-web-${var.environment}"
    Environment = var.environment
    Project     = var.project_name
    Owner       = var.owner
  }
}

output "public_ip" {
  description = "Public IP of the production web server"
  value       = aws_instance.web.public_ip
}

output "instance_id" {
  description = "Instance ID of the production web server"
  value       = aws_instance.web.id
}

output "dev_subnet_referenced" {
  description = "Subnet ID read from dev remote state"
  value       = data.terraform_remote_state.dev.outputs.subnet_id
}
