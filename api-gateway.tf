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
module "proxy-endpoint" {
  source          = "./module/api-endpoint"
  api             = aws_apigatewayv2_api.rest_api
  api_path        = "GET /{proxy+}"
  lambda_function = aws_lambda_function.test_lambda
}

module "entries-endpoint" {
  source          = "./module/api-endpoint"
  api             = aws_apigatewayv2_api.rest_api
  api_path        = "GET /_entries"
  lambda_function = aws_lambda_function._entries
}
