# Primary SNS Topic for Environment Alerts
resource "aws_sns_topic" "main" {
  name = "${terraform.workspace}-alerts"
}

