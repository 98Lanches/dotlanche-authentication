################## AUTHENTICATION ##############################

resource "aws_apigatewayv2_route" "getuser" {
  api_id = aws_apigatewayv2_api.apigateway.id

  route_key = "GET /get-user/{cpf}"
  target    = "integrations/${aws_apigatewayv2_integration.getuser.id}"
}

resource "aws_apigatewayv2_route" "signup" {
  api_id = aws_apigatewayv2_api.apigateway.id

  route_key = "POST /sign-up"
  target    = "integrations/${aws_apigatewayv2_integration.signup.id}"
}

resource "aws_apigatewayv2_route" "signin" {
  api_id = aws_apigatewayv2_api.apigateway.id

  route_key = "POST /sign-in"
  target    = "integrations/${aws_apigatewayv2_integration.signin.id}"
}

################## EKS ##############################

resource "aws_apigatewayv2_route" "proxy" {
  api_id = aws_apigatewayv2_api.apigateway.id

  route_key          = "ANY /{proxy+}"
  authorization_type = "JWT"
  authorizer_id      = aws_apigatewayv2_authorizer.users-authorizer.id
  target             = "integrations/${aws_apigatewayv2_integration.private-loadbalancer-integration.id}"
}
