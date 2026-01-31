# for EC2 instance

# Key pair
resource "aws_key_pair" "my_key" {
  key_name   = "${var.env}-infra-app-key"
  public_key = file("terra-ec2.pub")

  tags = {
    Environment = var.env
  }
}

# VPC
resource "aws_default_vpc" "default" {
  tags = {
    Name = "Default VPC"
  }
}

# Security Group
resource "aws_security_group" "allow_ssh_http" {
  name        = "${var.env}-infra-app-sg"
  description = "Allow SSH and HTTP inbound traffic"
  vpc_id      = aws_default_vpc.default.id

  # inbound rules
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow SSH access"
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow HTTP access"
  }

  # outbound rules
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1" # -1 means all protocols
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow all outbound traffic"
  }

  tags = {
    Name        = "${var.env}-infra-app-sg"
    Environment = var.env
  }
}

# EC2 Instance
resource "aws_instance" "my_ec2_instance" {
  count = var.instance_count
  key_name        = aws_key_pair.my_key.key_name
  security_groups = [aws_security_group.allow_ssh_http.name]
  instance_type   = var.instance_type
  ami             = var.ec2_ami_id

  depends_on = [aws_security_group.allow_ssh_http, aws_key_pair.my_key]

  root_block_device {
    volume_size           = var.env == "prod" ? 20 : var.ec2_default_root_storage_size
    volume_type           = "gp3"
    delete_on_termination = true
  }

  tags = {
    Name        = "${var.env}-infra-app-instance"
    Environment = var.env
  }
}