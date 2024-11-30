locals {
  anonymousUser = "anonymous"
  anonymousPass = "#anonymous8796#"
}

#### USERS ######
resource "aws_cognito_user_pool" "users-pool" {
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
  domain       = "dotlanches-1"
  user_pool_id = aws_cognito_user_pool.users-pool.id
}

resource "aws_cognito_user_pool_client" "users-client" {
  name            = "dotlanches-1-users-client"
  user_pool_id    = aws_cognito_user_pool.users-pool.id
  generate_secret = true
}

resource "aws_cognito_user" "anonymous-user" {
  user_pool_id = aws_cognito_user_pool.users-pool.id
  username     = local.anonymousUser
  password     = local.anonymousPass

  attributes = {
    name           = "Anonymous Login"
    email          = "support@dotlanches.com"
    email_verified = true
  }
}