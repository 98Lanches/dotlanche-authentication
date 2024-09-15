
resource "aws_apigatewayv2_api" "apigateway" {
  name          = "dotlanches-api-gateway"
  protocol_type = "HTTP"
}

resource "aws_apigatewayv2_stage" "apigateway-stage" {
  api_id = aws_apigatewayv2_api.apigateway.id

  name        = "v1"
  auto_deploy = true
}

output "api_gateway_url" {
  description = "Base URL for API Gateway"

  value = aws_apigatewayv2_stage.apigateway-stage.invoke_url
}

################## SIGN UP ##############################

resource "aws_apigatewayv2_integration" "signup" {
  api_id = aws_apigatewayv2_api.apigateway.id

  integration_uri    = aws_lambda_function.signup.invoke_arn
  integration_type   = "AWS_PROXY"
  integration_method = "POST"
}

resource "aws_apigatewayv2_route" "signup" {
  api_id = aws_apigatewayv2_api.apigateway.id

  route_key = "POST /sign-up"
  target    = "integrations/${aws_apigatewayv2_integration.signup.id}"
}

resource "aws_lambda_permission" "signup" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.signup.function_name
  principal     = "apigateway.amazonaws.com"

  source_arn = "${aws_apigatewayv2_api.apigateway.execution_arn}/*/*"
}

################## GET USER ##############################

resource "aws_apigatewayv2_integration" "getuser" {
  api_id = aws_apigatewayv2_api.apigateway.id

  integration_uri    = aws_lambda_function.getuser.invoke_arn
  integration_type   = "AWS_PROXY"
  integration_method = "POST"
}

resource "aws_apigatewayv2_route" "getuser" {
  api_id = aws_apigatewayv2_api.apigateway.id

  route_key = "GET /get-user/{cpf}"
  target    = "integrations/${aws_apigatewayv2_integration.getuser.id}"
}

resource "aws_lambda_permission" "getuser" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.getuser.function_name
  principal     = "apigateway.amazonaws.com"

  source_arn = "${aws_apigatewayv2_api.apigateway.execution_arn}/*/*"
}

################## SIGN IN ##############################

resource "aws_apigatewayv2_integration" "signin" {
  api_id = aws_apigatewayv2_api.apigateway.id

  integration_uri    = aws_lambda_function.signin.invoke_arn
  integration_type   = "AWS_PROXY"
  integration_method = "POST"
}

resource "aws_apigatewayv2_route" "signin" {
  api_id = aws_apigatewayv2_api.apigateway.id

  route_key = "POST /sign-in"
  target    = "integrations/${aws_apigatewayv2_integration.signin.id}"
}

resource "aws_lambda_permission" "signin" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.signin.function_name
  principal     = "apigateway.amazonaws.com"

  source_arn = "${aws_apigatewayv2_api.apigateway.execution_arn}/*/*"
}