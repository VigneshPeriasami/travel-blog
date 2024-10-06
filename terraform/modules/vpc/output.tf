output "default_vpc" {
  value = data.aws_vpc.default
  description = "Default VPC pre created in aws"
}

output "public_subnet" {
  value = data.aws_subnet.public
}

output "private_subnet" {
  value = data.aws_subnet.private
}
