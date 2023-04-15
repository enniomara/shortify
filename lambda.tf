locals {
  lambda_zip_location = "outputs/lambda_function_payload.zip"
}

data "archive_file" "service" {
  type        = "zip"
  source_dir  = "./src/"
  output_path = local.lambda_zip_location
  excludes    = ["__pycache__", ".pytest_cache"]
}

resource "aws_lambda_function" "test_lambda" {
  filename      = local.lambda_zip_location
  function_name = "shortify-path"
  role          = aws_iam_role.iam_for_lambda.arn
  handler       = "shortify.handlers.path_handler"

  # The filebase64sha256() function is available in Terraform 0.11.12 and later
  # For Terraform 0.11.11 and earlier, use the base64sha256() function and the file() function:
  # source_code_hash = "${base64sha256(file("lambda_function_payload.zip"))}"
  source_code_hash = data.archive_file.service.output_base64sha256
  runtime          = "python3.8"
  timeout          = 1
}

resource "aws_lambda_function" "_entries" {
  filename      = local.lambda_zip_location
  function_name = "shortify-entries"
  role          = aws_iam_role.iam_for_lambda.arn
  handler       = "shortify.handlers.entries_handler"

  # The filebase64sha256() function is available in Terraform 0.11.12 and later
  # For Terraform 0.11.11 and earlier, use the base64sha256() function and the file() function:
  # source_code_hash = "${base64sha256(file("lambda_function_payload.zip"))}"
  source_code_hash = data.archive_file.service.output_base64sha256
  runtime          = "python3.8"
  timeout          = 1
}
