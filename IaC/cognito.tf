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

resource "aws_cognito_user_pool_domain" "cognito-domain" {
  domain       = "dotlanches"
  user_pool_id = "${aws_cognito_user_pool.pool.id}"
}

resource "aws_cognito_user_pool_client" "client" {
  name            = "dotlanche-auth-client"
  user_pool_id    = aws_cognito_user_pool.pool.id
  generate_secret = true
}