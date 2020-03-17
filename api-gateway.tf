resource "aws_api_gateway_account" "demo" {
  cloudwatch_role_arn = aws_iam_role.iam_for_apigateway.arn
}

resource "aws_api_gateway_rest_api" "rest_api" {
  name = "Serverless API"
}

module "proxy-endpoint" {
  source                     = "./module/api-endpoint"
  rest_api_id                = aws_api_gateway_rest_api.rest_api.id
  parent_id                  = aws_api_gateway_rest_api.rest_api.root_resource_id
  path                       = "{proxy+}"
  lambda_function_invoke_arn = aws_lambda_function.test_lambda.invoke_arn
}

resource "aws_api_gateway_deployment" "example" {
  depends_on = [
    module.proxy-endpoint.integration
  ]

  rest_api_id = aws_api_gateway_rest_api.rest_api.id
  stage_name  = "test"
  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_lambda_permission" "apigw" {
  statement_id  = "AllowAPIGatewayInvoke"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.test_lambda.function_name
  principal     = "apigateway.amazonaws.com"

  # The "/*/*" portion grants access from any method on any resource
  # within the API Gateway REST API.
  source_arn = "${aws_api_gateway_rest_api.rest_api.execution_arn}/*/*"
}

output "base_url" {
  value = aws_api_gateway_deployment.example.invoke_url
}
