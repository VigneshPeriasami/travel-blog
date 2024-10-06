packer {
  required_plugins {
    amazon = {
      version = ">= 1.2.8"
      source  = "github.com/hashicorp/amazon"
    }
  }
}

variable "webserver_ami_name" {
  type        = string
  description = "Web server AMI name"
  sensitive   = false
}

variable "docker_file_path" {
  type        = string
  description = "Aws docker file location"
  sensitive   = false
}

source "amazon-ebs" "webserver-ami" {
  ami_name      = var.webserver_ami_name
  instance_type = "t2.micro"
  region        = "us-east-2"
  source_ami_filter {
    filters = {
      name                = "amzn2-ami-kernel-5.10-hvm-2.*.0-x86_64-gp2"
      root-device-type    = "ebs"
      virtualization-type = "hvm"
    }
    most_recent = true
    owners      = ["amazon"]
  }
  ssh_username = "ec2-user"
}

build {
  sources = [
    "source.amazon-ebs.webserver-ami"
  ]

  provisioner "file" {
    source      = "./packer/instance-scripts/app.service"
    destination = "/home/ec2-user/app.service"
  }

  provisioner "file" {
    source      = var.docker_file_path
    destination = "/home/ec2-user/docker-compose.aws.yml"
  }

  provisioner "shell" {
    script = "./packer/instance-scripts/setup.sh"
  }
}
