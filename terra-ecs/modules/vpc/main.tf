terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.16"
    }
  }
  required_version = ">= 1.2.0"
}

data "aws_vpc" "auth-vpc" {
  id = "vpc-0c81488cadd864779"
}

data "aws_subnet" "public-subnet" {
  filter {
    name   = "tag:Name"
    values = ["project-subnet-public1"]
  }
}

data "aws_subnet" "private-subnet" {
  filter {
    name   = "tag:Name"
    values = ["project-subnet-private1"]
  }
}

resource "aws_security_group" "example-sg" {
  name   = "example-sg"
  vpc_id = data.aws_vpc.auth-vpc.id
  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
}

resource "aws_vpc_security_group_ingress_rule" "allow_ipv4_app" {
  security_group_id = aws_security_group.example-sg.id

  cidr_ipv4   = "0.0.0.0/0"
  from_port   = 3000
  ip_protocol = "tcp"
  to_port     = 3000
}

resource "aws_vpc_security_group_ingress_rule" "allow_ssh_app" {
  security_group_id = aws_security_group.example-sg.id

  cidr_ipv4   = "0.0.0.0/0"
  from_port   = 22
  ip_protocol = "tcp"
  to_port     = 22
}
