resource "aws_apigatewayv2_authorizer" "users-authorizer" {
  name                              = "dotlanche-user-authorizer"
  api_id                            = aws_apigatewayv2_api.apigateway.id
  identity_sources                  = ["$request.header.Authorization"]
  authorizer_type                   = "JWT"

  jwt_configuration {
    audience = [ aws_cognito_user_pool_client.users-client.id ]
    issuer = "https://${aws_cognito_user_pool.users-pool.endpoint}"
  }
}

resource "aws_apigatewayv2_authorizer" "management-authorizer" {
  name                              = "dotlanche-management-authorizer"
  api_id                            = aws_apigatewayv2_api.apigateway.id
  identity_sources                  = ["$request.header.Authorization"]
  authorizer_type                   = "JWT"

  jwt_configuration {
    audience = [ aws_cognito_user_pool_client.management-client.id ]
    issuer = "https://${aws_cognito_user_pool.management-pool.endpoint}"
  }
}