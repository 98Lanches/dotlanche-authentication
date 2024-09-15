provider "aws" {
  region = "us-east-1"
}

################# BEGIN COGNITO ###################################
resource "aws_cognito_user_pool" "pool" {
  name = "dotlanches-users"
  password_policy {
    minimum_length    = 8
    require_lowercase = false
    require_numbers   = false
    require_symbols   = false
    require_uppercase = false
  }

  verification_message_template {
    default_email_option = "CONFIRM_WITH_LINK"
  }

  email_configuration {
    email_sending_account = "COGNITO_DEFAULT"
  }

  auto_verified_attributes = ["email"]

  schema {
    name                = "email"
    attribute_data_type = "String"
    required            = true
    mutable             = true
  }
  schema {
    name                = "name"
    attribute_data_type = "String"
    required            = true
    mutable             = true
  }

  account_recovery_setting {
    recovery_mechanism {
      name     = "verified_email"
      priority = 1
    }
  }
}

resource "aws_cognito_user_pool_client" "client" {
  name            = "dotlanche-auth-client"
  user_pool_id    = aws_cognito_user_pool.pool.id
  generate_secret = true
}
################# END COGNITO ###################################

################# BEGIN LAMBDAS ###################################
resource "aws_lambda_function" "signup" {
  function_name = "dotlanches-signup"
  role          = "arn:aws:iam::032963977760:role/LabRole"
  memory_size   = 256
  runtime       = "dotnet8"
  filename      = "../src/DotlancheAuthentication/bin/Release/net8.0/DotlancheAuthentication.zip"
  handler       = "DotlancheAuthentication::DotlancheAuthentication.Functions_SignUp_Generated::SignUp" #Class is build from a source generator
  environment {
    variables = {
      "COGNITO_USER_POOL"    = aws_cognito_user_pool.pool.id
      "COGNITO_CLIENTID"     = aws_cognito_user_pool_client.client.id
      "COGNITO_CLIENTSECRET" = aws_cognito_user_pool_client.client.client_secret
      "ACCESS_KEY"           = ""
      "SECRET_KEY"           = ""
      "TOKEN"                = ""
    }
  }
}
################# END LAMBDAS ###################################

################# BEGIN APIGATEWAY ###################################
resource "aws_apigatewayv2_api" "apigateway" {
  name          = "dotlanches-api-gateway"
  protocol_type = "HTTP"
}

resource "aws_apigatewayv2_stage" "apigateway-stage" {
  api_id = aws_apigatewayv2_api.apigateway.id

  name        = "v1"
  auto_deploy = true
}

## SIGN UP LAMBDA ##

resource "aws_apigatewayv2_integration" "sign-up" {
  api_id = aws_apigatewayv2_api.apigateway.id

  integration_uri    = aws_lambda_function.signup.invoke_arn
  integration_type   = "AWS_PROXY"
  integration_method = "POST"
}

resource "aws_apigatewayv2_route" "sign-up" {
  api_id = aws_apigatewayv2_api.apigateway.id

  route_key = "POST /sign-up"
  target    = "integrations/${aws_apigatewayv2_integration.sign-up.id}"
}

resource "aws_lambda_permission" "sign-up" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.signup.function_name
  principal     = "apigateway.amazonaws.com"

  source_arn = "${aws_apigatewayv2_api.apigateway.execution_arn}/*/*"
}



################# END APIGATEWAY ###################################


