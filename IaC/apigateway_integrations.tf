################### GET USER LAMBDA

resource "aws_apigatewayv2_integration" "getuser" {
  api_id = aws_apigatewayv2_api.apigateway.id

  integration_uri    = aws_lambda_function.getuser.invoke_arn
  integration_type   = "AWS_PROXY"
  integration_method = "POST"
}

resource "aws_lambda_permission" "getuser" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.getuser.function_name
  principal     = "apigateway.amazonaws.com"

  source_arn = "${aws_apigatewayv2_api.apigateway.execution_arn}/*/*"
}

################### SIGN UP LAMBDA

resource "aws_apigatewayv2_integration" "signup" {
  api_id = aws_apigatewayv2_api.apigateway.id

  integration_uri    = aws_lambda_function.signup.invoke_arn
  integration_type   = "AWS_PROXY"
  integration_method = "POST"
}

resource "aws_lambda_permission" "signup" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.signup.function_name
  principal     = "apigateway.amazonaws.com"

  source_arn = "${aws_apigatewayv2_api.apigateway.execution_arn}/*/*"
}

################### SIGN IN LAMBDA

resource "aws_apigatewayv2_integration" "signin" {
  api_id = aws_apigatewayv2_api.apigateway.id

  integration_uri    = aws_lambda_function.signin.invoke_arn
  integration_type   = "AWS_PROXY"
  integration_method = "POST"
}

resource "aws_lambda_permission" "signin" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.signin.function_name
  principal     = "apigateway.amazonaws.com"

  source_arn = "${aws_apigatewayv2_api.apigateway.execution_arn}/*/*"
}

################### DOTLANCHES API

resource "aws_apigatewayv2_integration" "private-loadbalancer-integration" {
  api_id           = aws_apigatewayv2_api.apigateway.id
  credentials_arn  = var.functions_role
  description      = "Load Balancer Integration"
  integration_type = "HTTP_PROXY"
  integration_uri  = aws_lb_listener.dotlanche_api_listener.arn

  integration_method = "ANY"
  connection_type    = "VPC_LINK"
  connection_id      = aws_apigatewayv2_vpc_link.apigateway-vpc_link.id
}
