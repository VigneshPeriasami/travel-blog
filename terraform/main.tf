terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.16"
    }
  }

  required_version = ">= 1.2.0"
}

provider "aws" {
  region = "us-east-2"
}

data "aws_ami" "auth-server-ami" {
  most_recent = true
  filter {
    name   = "name"
    values = ["auth-server-ami"]
  }

  owners = ["self"]
}

data "aws_ami" "backend_server_ami" {
  most_recent = true
  filter {
    name = "name"
    values = ["backend-server-ami"]
  }
  owners = ["self"]
}

module "vpc" {
  source = "./modules/vpc"
}

module "auth_security_group" {
  source = "./modules/security_group/"
  app_name = "auth_server"
  app_port = 3000
  vpc_id = module.vpc.default_vpc.id
}

resource "aws_instance" "auth-server" {
  ami                         = data.aws_ami.auth-server-ami.id
  instance_type               = "t2.micro"
  vpc_security_group_ids      = [module.auth_security_group.security_group.id]
  subnet_id                   = module.vpc.public_subnet.id
  associate_public_ip_address = true
  private_ip                  = "10.0.0.10"
  key_name                    = "first-instance-keypair"
  tags = {
    Name = "AuthServerInstance"
  }
}

module "backend_security_group" {
  source = "./modules/security_group/"
  app_name = "backend_server"
  app_port = 8080
  vpc_id = module.vpc.default_vpc.id
}

resource "aws_instance" "backend-server" {
  ami                         = data.aws_ami.backend_server_ami.id
  instance_type               = "t2.micro"
  vpc_security_group_ids      = [module.backend_security_group.security_group.id]
  subnet_id                   = module.vpc.public_subnet.id
  associate_public_ip_address = true
  private_ip                  = "10.0.0.11"
  key_name                    = "first-instance-keypair"
  tags = {
    Name = "BackendServerInstance"
  }
}
