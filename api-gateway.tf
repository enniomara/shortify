resource "aws_api_gateway_account" "demo" {
  cloudwatch_role_arn = aws_iam_role.iam_for_apigateway.arn
}

resource "aws_apigatewayv2_api" "rest_api" {
  name          = "Serverless API"
  protocol_type = "HTTP"

  # to enable requests through custom domain
  disable_execute_api_endpoint = true
}

resource "aws_apigatewayv2_stage" "rest_api" {
  api_id      = aws_apigatewayv2_api.rest_api.id
  name        = "default"
  auto_deploy = true
}

resource "aws_apigatewayv2_authorizer" "jwt" {
  count            = var.authorizer_configuration == null ? 0 : 1
  api_id           = aws_apigatewayv2_api.rest_api.id
  authorizer_type  = "JWT"
  identity_sources = ["$request.header.Authorization"]
  name             = "example-authorizer"

  dynamic "jwt_configuration" {
    for_each = var.authorizer_configuration == null ? [] : [1]
    content {
      issuer   = var.authorizer_configuration.issuer
      audience = var.authorizer_configuration.audience
    }
  }
}

module "proxy-endpoint" {
  source          = "./module/api-endpoint"
  api             = aws_apigatewayv2_api.rest_api
  api_path        = "GET /{proxy+}"
  lambda_function = aws_lambda_function.test_lambda

  authorizer = try(aws_apigatewayv2_authorizer.jwt[0], null)
}

module "entries-endpoint" {
  source          = "./module/api-endpoint"
  api             = aws_apigatewayv2_api.rest_api
  api_path        = "GET /_entries"
  lambda_function = aws_lambda_function._entries

  authorizer = try(aws_apigatewayv2_authorizer.jwt[0], null)
}
