
provider "aws" {
  region = "us-east-1"  
}


resource "aws_vpc" "my_vpc" {
  cidr_block = "10.0.0.0/16"
}


resource "aws_subnet" "public_subnet" {
  vpc_id                  = "vpc-0a9f6850104e9d4ad"
  cidr_block              = "172.31.0.0/16"
  availability_zone       = "us-east-1a"  
  map_public_ip_on_launch = true
}


resource "aws_subnet" "private_subnet" {
  vpc_id                  = "vpc-0a9f6850104e9d4ad"
  cidr_block              = "172.31.0.0/16"
  availability_zone       = "us-east-1b"  
}


resource "aws_security_group" "my_security_group" {
  name        = "my-security-group"
  description = "Allow SSH inbound and all outbound traffic"
  vpc_id      = "vpc-0a9f6850104e9d4ad"

  
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}


resource "aws_instance" "my_instance" {
  ami           = "ami-0373aa64534d82bf6"  
  instance_type = "t2.micro"
  subnet_id     = "subnet-030fb4b5a868dad3d"
  key_name      = "demo01"  
  associate_public_ip_address = true

 
  security_groups = ["default"]

 
  user_data = <<-EOF
              #!/bin/bash
              echo "Hello, Terraform!" > index.html
              nohup python -m SimpleHTTPServer 80 &
              EOF

 
  root_block_device {
    volume_size = 8
    volume_type = "gp2"
  }

 
  tags = {
    Name    = "my-instance"
    purpose = "Assignment"
  }
}
