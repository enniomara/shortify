resource "aws_iam_role" "iam_for_lambda" {
  name_prefix = "iam_for_lambda-"
  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = "sts:AssumeRole",
        Principal = {
          Service = "lambda.amazonaws.com"
        },
        Effect = "Allow",
        Sid    = ""
      }
    ]
  })
}

resource "aws_iam_role" "iam_for_apigateway" {
  name_prefix = "apigateway_to_cloudwatch-"
  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = "sts:AssumeRole",
        Principal = {
          Service = "apigateway.amazonaws.com"
        },
        Effect = "Allow",
        Sid    = ""
      }
    ]
  })
}

resource "aws_iam_role_policy" "dynamodb_policy" {
  name_prefix = "iam_for_lambda_dynamodb"
  role        = aws_iam_role.iam_for_lambda.id
  policy = jsonencode({
    Version : "2012-10-17",
    Statement : [
      {
        Effect = "Allow",
        Action = [
          "dynamodb:*"
        ],
        Resource = aws_dynamodb_table.shortify-table.arn
      },
      {
        Effect = "Allow",
        Action = [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ],
        Resource = "*"
      }
    ]
  })
}

resource "aws_iam_role_policy" "apigateway_push_to_cloudwatch" {
  name_prefix = "apigateway_push_to_cloudwatch"
  role        = aws_iam_role.iam_for_apigateway.id
  policy = jsonencode({
    Version : "2012-10-17",
    Statement : [
      {
        Effect = "Allow",
        Action = [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:DescribeLogGroups",
          "logs:DescribeLogStreams",
          "logs:PutLogEvents",
          "logs:GetLogEvents",
          "logs:FilterLogEvents"
        ],
        Resource = "*"
      }
    ]
  })
}
