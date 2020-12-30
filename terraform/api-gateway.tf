resource "aws_api_gateway_account" "demo" {
  cloudwatch_role_arn = aws_iam_role.iam_for_apigateway.arn
}

resource "aws_api_gateway_rest_api" "rest_api" {
  name = "Serverless API"
}

module "proxy-endpoint" {
  source          = "./module/api-endpoint"
  rest_api        = aws_api_gateway_rest_api.rest_api
  path            = "{proxy+}"
  lambda_function = aws_lambda_function.test_lambda
}

module "entries-endpoint" {
  source          = "./module/api-endpoint"
  rest_api        = aws_api_gateway_rest_api.rest_api
  path            = "_entries"
  lambda_function = aws_lambda_function._entries
}

resource "aws_api_gateway_deployment" "example" {
  depends_on = [
    module.proxy-endpoint.integration,
    module.entries-endpoint.integration,
  ]

  rest_api_id = aws_api_gateway_rest_api.rest_api.id
  stage_name  = "test"
  lifecycle {
    create_before_destroy = true
  }
}

output "base_url" {
  value = aws_api_gateway_deployment.example.invoke_url
}
