provider "aws" {
  region = var.aws_region
}

resource "aws_dynamodb_table" "employee" {

  name         = "EmployeeTerraformDemo"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "EmployeeID"

  attribute {
    name = "EmployeeID"
    type = "S"
  }

  tags = {
    Environment = var.environment
    Owner       = var.owner
  }
}

resource "aws_sns_topic" "notifications" {
  name = "terraform-notifications"
}

output "dynamodb_table_name" {
  value = aws_dynamodb_table.employee.name
}

output "sns_topic_arn" {
  value = aws_sns_topic.notifications.arn
}

output "api_url" {
  value = aws_apigatewayv2_stage.prod.invoke_url
}
