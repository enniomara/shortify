locals {
  hash_key_name = "name"
}

resource "aws_dynamodb_table" "shortify-table" {
  name         = "Shortify"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = local.hash_key_name

  attribute {
    name = local.hash_key_name
    type = "S"
  }
}
