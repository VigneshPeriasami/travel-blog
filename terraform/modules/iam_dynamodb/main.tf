
variable "app_name" {
  type = string
  description = "App name for the IAM role"
}

variable "app_environment" {
  type = string
  description = "App environment for the IAM role"
}

output "dynamodb_role" {
  value = aws_iam_role.dynamodb_role
  description = "Dynamodb IAM role ref"
}

output "dynamodb_profile" {
  value = aws_iam_instance_profile.dynamodb_profile
}

resource "aws_iam_role" "dynamodb_role" {
  name               = "${var.app_name}-dynamodb-role"
  assume_role_policy = data.aws_iam_policy_document.assume_role_policy.json
  tags = {
    Name        = "${var.app_name}-iam-role"
    Environment = var.app_environment
  }
}

resource "aws_iam_instance_profile" "dynamodb_profile" {
  name = "test_profile"
  role = aws_iam_role.dynamodb_role.name
}

data "aws_iam_policy_document" "assume_role_policy" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

resource "aws_iam_role_policy_attachment" "dynamodb_role_policy" {
  role       = aws_iam_role.dynamodb_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonDynamoDBFullAccess"
}
