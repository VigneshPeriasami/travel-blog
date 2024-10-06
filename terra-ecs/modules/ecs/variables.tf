variable "app_name" {
  type = string
  description = "App name"
}

variable "app_environment" {
  type = string
  description = "App environment"
  default = "dev"
}

variable "app_port" {
  type = number
  description = "App container and host port"
}

variable "subnet_id" {
  type = string
  description = "Subnet id for the ecs service"
}

variable "security_group_id" {
  type = string
  description = "Security group id for the ecs service"
}

variable "ecr_repo_name" {
  type = string
  description = "ECR repository name to be fetched for the ecs task definition"
}

variable "task_execution_role_arn" {
  type = string
  description = "Task execution role arn for ecs task definition"
}
