# multiple state files in the same backend, same code directory. 

terraform {
  backend "s3" {
    bucket       = "belinda-terraform-state-30daychallenge"
    key          = "day7/workspaces/terraform.tfstate"
    region       = "us-east-1"
    use_lockfile = true
    encrypt      = true
  }
}

provider "aws" {
  region = var.aws_region
}

# Security Group

resource "aws_security_group" "web_sg" {
  name        = "belinda-web-sg-${terraform.workspace}"
  description = "Web server SG for ${terraform.workspace} environment"

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
    Name        = "belinda-web-sg-${terraform.workspace}"
    Environment = terraform.workspace
    Project     = var.project_name
    Owner       = var.owner
  }
}

# EC2 Instance

resource "aws_instance" "web" {
  ami                    = var.ami_id
  instance_type          = var.instance_type[terraform.workspace]
  vpc_security_group_ids = [aws_security_group.web_sg.id]

  user_data = <<-EOF
              #!/bin/bash
              yum update -y
              yum install -y httpd
              systemctl start httpd
              systemctl enable httpd
              echo "<h1>Environment: ${terraform.workspace}</h1><p>Belinda Ntinyari — Day 7 Terraform Challenge</p>" > /var/www/html/index.html
              EOF

  tags = {
    Name        = "belinda-web-${terraform.workspace}"
    Environment = terraform.workspace
    Project     = var.project_name
    Owner       = var.owner
  }
}


# Outputs

output "instance_id" {
  description = "ID of the EC2 instance in this workspace"
  value       = aws_instance.web.id
}

output "public_ip" {
  description = "Public IP of the web server"
  value       = aws_instance.web.public_ip
}

output "environment" {
  description = "Active Terraform workspace (environment)"
  value       = terraform.workspace
}

output "instance_type_used" {
  description = "Instance type deployed in this workspace"
  value       = aws_instance.web.instance_type
}
