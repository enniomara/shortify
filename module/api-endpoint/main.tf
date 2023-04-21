
resource "aws_apigatewayv2_integration" "lambda" {
  api_id           = var.api.id
  integration_type = "AWS_PROXY"
  integration_uri  = var.lambda_function.invoke_arn
}

resource "aws_apigatewayv2_route" "example" {
  api_id    = var.api.id
  route_key = var.api_path

  target = "integrations/${aws_apigatewayv2_integration.lambda.id}"
}

resource "aws_lambda_permission" "rest" {
  statement_id  = "AllowAPIGatewayInvoke"
  action        = "lambda:InvokeFunction"
  function_name = var.lambda_function.function_name
  principal     = "apigateway.amazonaws.com"

  # The "/*/*" portion grants access from any method on any resource
  # within the API Gateway REST API.
  source_arn = "${var.api.execution_arn}/*/*"
}
