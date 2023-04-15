provider "aws" {
  region = "eu-north-1"
  assume_role {
    role_arn = var.workspace_assume_role_arn[terraform.workspace]
  }
}
