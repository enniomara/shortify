terraform {
  required_providers {
    archive = {
      source  = "hashicorp/archive"
      version = "~>2.3.0"
    }
    aws = {
      source  = "hashicorp/aws"
      version = "~>3.0"
    }
  }
  required_version = ">= 0.13"
}
