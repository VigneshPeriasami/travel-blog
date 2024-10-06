variable "app_name" {
  type = string
  description = "App name for the security group"
}

variable "app_port" {
  type = number
  description = "App port number to be accessed in public"
}

variable "vpc_id" {
  type = string
  description = "VPC id on which to create the security group"
}
