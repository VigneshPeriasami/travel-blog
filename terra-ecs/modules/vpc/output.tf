
output "public-subnet" {
  value = data.aws_subnet.public-subnet
  description = "Public subnet ref"
}

output "aws-vpc" {
  value = data.aws_vpc.auth-vpc
  description = "VPC ref"
}

output "security-group" {
  value = aws_security_group.example-sg
  description = "Security group ref"
}
