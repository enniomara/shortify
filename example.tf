locals {
  lambda_zip_location = "outputs/lambda_function_payload.zip"
}

data "archive_file" "service" {
  type = "zip"
  source_dir = "service/"
  output_path = local.lambda_zip_location
}

resource "aws_lambda_function" "test_lambda" {
  filename = local.lambda_zip_location
  function_name = "example"
  role          = aws_iam_role.iam_for_lambda.arn
  handler       = "service.handler"

  # The filebase64sha256() function is available in Terraform 0.11.12 and later
  # For Terraform 0.11.11 and earlier, use the base64sha256() function and the file() function:
  # source_code_hash = "${base64sha256(file("lambda_function_payload.zip"))}"
  source_code_hash = data.archive_file.service.output_sha
  runtime = "nodejs12.x"
}
