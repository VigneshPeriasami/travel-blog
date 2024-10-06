terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.16"
    }
  }

  required_version = ">= 1.2.0"
}

data "aws_vpc" "default" {
  id = "vpc-0c81488cadd864779"
}

data "aws_subnet" "public" {
  filter {
    name   = "tag:Name"
    values = ["project-subnet-public1"]
  }
}

data "aws_subnet" "private" {
  filter {
    name   = "tag:Name"
    values = ["project-subnet-private1"]
  }
}
