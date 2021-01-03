resource "aws_iam_role" "iam_for_lambda" {
  name               = "iam_for_lambda"
  assume_role_policy = file("iam/iam_role_lambda.json")
}

resource "aws_iam_role" "iam_for_apigateway" {
  name               = "apigateway_to_cloudwatch"
  assume_role_policy = file("iam/iam_role_apigateway.json")
}

resource "aws_iam_role_policy" "dynamodb_policy" {
  name = "iam_for_lambda_dynamodb"
  role = aws_iam_role.iam_for_lambda.id
  policy = templatefile("iam/iam_role_lambda_dynamodb.json", {
    "resource_arn" : aws_dynamodb_table.shortify-table.arn
  })
}

resource "aws_iam_role_policy" "apigateway_push_to_cloudwatch" {
  name   = "apigateway_push_to_cloudwatch"
  role   = aws_iam_role.iam_for_apigateway.id
  policy = file("iam/iam_policy_apigateway.json")
}
