provider "aws" {
  region = "eu-north-1"
  assume_role {
    role_arn = var.workspace_iam_role_arn[terraform.workspace]
  }
}

variable "workspace_iam_role_arn" {
  default = {
    default = null # No ARN is assumed here in order to have a simple "terraform up" when first starting.
    staging = "abc"
  }
}
