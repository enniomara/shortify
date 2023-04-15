# Shortify example deployment

This folder shows Terraform code that is able to deploy Shortify on your AWS account.

## Quick Start

1. `git clone` this repo to your computer.
2. Install Terraform.
3. Run `terraform init`.
4. Run `terraform apply` to deploy. When this command finishes running, it will
   output a link where API requests can be sent. See
   [here](https://docs.aws.amazon.com/apigateway/latest/developerguide/how-to-custom-domains.html)
   if you want the API to be accessible via a custom domain.
