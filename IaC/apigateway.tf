data "aws_vpc" "vpc" {
  filter {
    name   = "tag:Project"
    values = ["Dotlanches"]
  }
}

data "aws_subnets" "private_subnets" {
  filter {
    name   = "tag:Project"
    values = ["Dotlanches"]
  }

  filter {
    name   = "tag:type"
    values = ["private"]
  }
}

data "aws_security_group" "eks_security_group" {
  filter {
    name   = "tag:aws:eks:cluster-name"
    values = ["dotcluster"]
  }
}

resource "aws_apigatewayv2_api" "apigateway" {
  name          = "dotlanches-api-gateway"
  protocol_type = "HTTP"
}

resource "aws_apigatewayv2_stage" "apigateway-stage" {
  api_id = aws_apigatewayv2_api.apigateway.id

  name        = "$default"
  auto_deploy = true
}

resource "aws_apigatewayv2_vpc_link" "apigateway-vpc_link" {
  name               = "EKS_LB"
  security_group_ids = [data.aws_security_group.eks_security_group.id]
  subnet_ids         = data.aws_subnets.private_subnets.ids
}

output "api_gateway_url" {
  description = "Base URL for API Gateway"

  value = aws_apigatewayv2_stage.apigateway-stage.invoke_url
}
