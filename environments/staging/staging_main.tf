provider "aws" {
  region = var.aws_region
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

resource "aws_instance" "web" {
  ami                    = var.ami_id
  instance_type          = var.instance_type
  vpc_security_group_ids = [aws_security_group.web_sg.id]

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
  description = "Public IP of the staging web server"
  value       = aws_instance.web.public_ip
}

output "instance_id" {
  description = "Instance ID of the staging web server"
  value       = aws_instance.web.id
}

output "subnet_id" {
  description = "Subnet ID"
  value       = aws_instance.web.subnet_id
}
