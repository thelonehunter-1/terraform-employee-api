###APIGateway###
resource "aws_apigatewayv2_api" "demo_api" {

  name          = "terraform-demo-api"
  protocol_type = "HTTP"

}
##Integration##
resource "aws_apigatewayv2_integration" "lambda_integration" {

  api_id                 = aws_apigatewayv2_api.demo_api.id
  integration_type       = "AWS_PROXY"
  integration_uri        = aws_lambda_function.demo.invoke_arn
  payload_format_version = "2.0"


}

##Route##
resource "aws_apigatewayv2_route" "hello_route" {
  api_id    = aws_apigatewayv2_api.demo_api.id
  route_key = "GET /hello"
  target    = "integrations/${aws_apigatewayv2_integration.lambda_integration.id}"

}

###Stage###
resource "aws_apigatewayv2_stage" "prod" {
  api_id      = aws_apigatewayv2_api.demo_api.id
  name        = "prod"
  auto_deploy = true

}

###AllowAPIGateway to Invoke Lambda###

resource "aws_lambda_permission" "apigw" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.demo.function_name
  principal     = "apigateway.amazonaws.com"

}

###POSTRoute###
resource "aws_apigatewayv2_route" "employee_route" {

  api_id = aws_apigatewayv2_api.demo_api.id
  route_key = "POST /employee"
  target = "integrations/${aws_apigatewayv2_integration.lambda_integration.id}"

}
###NEWROUTE###
resource "aws_apigatewayv2_route" "employee_get_route" {

  api_id = aws_apigatewayv2_api.demo_api.id

  route_key = "GET /employee/{EmployeeID}"

  target = "integrations/${aws_apigatewayv2_integration.lambda_integration.id}"
}

