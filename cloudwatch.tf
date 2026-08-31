resource "aws_cloudwatch_metric_alarm" "lambda_error_alarm" {
  alarm_name          = "Lambda-Error-Alarm"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = 1
  metric_name         = "Errors"
  namespace           = "AWS/Lambda"
  period              = 60
  statistic           = "Sum"
  threshold           = 1
  dimensions = {
    FunctionName = aws_lambda_function.demo.function_name
  }
  alarm_actions = [aws_sns_topic.notifications.arn
  ]



}

resource "aws_cloudwatch_metric_alarm" "api_5xx_alarm" {
  alarm_name          = "5xx-Error-Alarm"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = 1
  metric_name         = "5xx"
  namespace           = "AWS/ApiGateway"
  period              = 60
  statistic           = "Sum"
  threshold           = 1
  dimensions = {
    ApiId = aws_apigatewayv2_api.demo_api.id

  }
  alarms_actions = [aws_sns_topic.notifications.arn]

}


##CloudWatch Metrics###

resource "aws_cloudwatch_dashboard" "employee_dashboard" {
  dashboard_name = "Employee-API_New-Dashboard"
  dashboard_body = jsonencode({
    widgets = [
      {
        type   = metric
        x      = 0
        y      = 0
        width  = 12
        height = 6

        properties = {
          metrics = [
            [
              "AWS/Lambda",
              "Invocations",
              "FunctionName",
              aws_lambda_function.demo.function_name
            ]
          ]

          period = 300
          stat   = "Sum"
          region = "ap-south-1"
          title  = "Lambda Invocations"
        }
      },
      {
        type   = metric
        x      = 0
        y      = 0
        width  = 12
        height = 6

        properties = {
          metrics = [
            [
              "AWS/Lambda",
              "Errors",
              "FunctionName",
              aws_lambda_function.demo.function_name
            ]
          ]

          period = 300
          stat   = "Sum"
          region = "ap-south-1"
          title  = "Lambda Errors"
        }
      }
    ]
  })
}
