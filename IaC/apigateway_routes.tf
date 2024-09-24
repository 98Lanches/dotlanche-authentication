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

################## CUSTOMER ##############################

resource "aws_apigatewayv2_route" "create_pedido" {
  api_id = aws_apigatewayv2_api.apigateway.id

  route_key          = "POST /pedido"
  authorization_type = "JWT"
  authorizer_id      = aws_apigatewayv2_authorizer.users-authorizer.id
  target             = "integrations/${aws_apigatewayv2_integration.private-loadbalancer-integration.id}"
}

resource "aws_apigatewayv2_route" "pagamento_qr_code" {
  api_id = aws_apigatewayv2_api.apigateway.id

  route_key          = "POST /pagamento/qrcode"
  authorization_type = "JWT"
  authorizer_id      = aws_apigatewayv2_authorizer.users-authorizer.id
  target             = "integrations/${aws_apigatewayv2_integration.private-loadbalancer-integration.id}"
}

resource "aws_apigatewayv2_route" "pagamento_confirm" {
  api_id = aws_apigatewayv2_api.apigateway.id

  route_key          = "POST /pagamento/confirmar"
  authorization_type = "JWT"
  authorizer_id      = aws_apigatewayv2_authorizer.users-authorizer.id
  target             = "integrations/${aws_apigatewayv2_integration.private-loadbalancer-integration.id}"
}

resource "aws_apigatewayv2_route" "get_status_pagamento" {
  api_id = aws_apigatewayv2_api.apigateway.id

  route_key          = "GET /pagamento"
  authorization_type = "JWT"
  authorizer_id      = aws_apigatewayv2_authorizer.users-authorizer.id
  target             = "integrations/${aws_apigatewayv2_integration.private-loadbalancer-integration.id}"
}

resource "aws_apigatewayv2_route" "get_produto_by_categoria" {
  api_id = aws_apigatewayv2_api.apigateway.id

  route_key          = "GET /produto"
  authorization_type = "JWT"
  authorizer_id      = aws_apigatewayv2_authorizer.users-authorizer.id
  target             = "integrations/${aws_apigatewayv2_integration.private-loadbalancer-integration.id}"
}

resource "aws_apigatewayv2_route" "get_produto_by_id" {
  api_id = aws_apigatewayv2_api.apigateway.id

  route_key          = "GET /produto/{produtoId}"
  authorization_type = "JWT"
  authorizer_id      = aws_apigatewayv2_authorizer.users-authorizer.id
  target             = "integrations/${aws_apigatewayv2_integration.private-loadbalancer-integration.id}"
}


resource "aws_apigatewayv2_route" "get_queue_pedidos" {
  api_id = aws_apigatewayv2_api.apigateway.id

  route_key          = "GET /pedido/queue"
  authorization_type = "JWT"
  authorizer_id      = aws_apigatewayv2_authorizer.users-authorizer.id
  target             = "integrations/${aws_apigatewayv2_integration.private-loadbalancer-integration.id}"
}

# ################## MANAGEMENT ##############################

resource "aws_apigatewayv2_route" "create_produto" {
  api_id = aws_apigatewayv2_api.apigateway.id

  route_key          = "POST /produto"
  authorization_type = "JWT"
  authorizer_id      = aws_apigatewayv2_authorizer.management-authorizer.id
  target             = "integrations/${aws_apigatewayv2_integration.private-loadbalancer-integration.id}"
}

resource "aws_apigatewayv2_route" "update_produto" {
  api_id = aws_apigatewayv2_api.apigateway.id

  route_key          = "PUT /produto/{produtoId}"
  authorization_type = "JWT"
  authorizer_id      = aws_apigatewayv2_authorizer.management-authorizer.id
  target             = "integrations/${aws_apigatewayv2_integration.private-loadbalancer-integration.id}"
}

resource "aws_apigatewayv2_route" "delete_produto" {
  api_id = aws_apigatewayv2_api.apigateway.id

  route_key          = "DELETE /produto/{produtoId}"
  authorization_type = "JWT"
  authorizer_id      = aws_apigatewayv2_authorizer.management-authorizer.id
  target             = "integrations/${aws_apigatewayv2_integration.private-loadbalancer-integration.id}"
}

resource "aws_apigatewayv2_route" "update_status_pedido" {
  api_id = aws_apigatewayv2_api.apigateway.id

  route_key          = "PUT /pedido/{pedidoId}"
  authorization_type = "JWT"
  authorizer_id      = aws_apigatewayv2_authorizer.management-authorizer.id
  target             = "integrations/${aws_apigatewayv2_integration.private-loadbalancer-integration.id}"
}
