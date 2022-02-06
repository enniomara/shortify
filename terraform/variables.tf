variable "workspace_assume_role_arn" {
  description = "For each Terraform workspace, contains the ARN with which Terraform will assume before provisioning infrastructure"
  type        = map(string)
  default = {
    default = null # No ARN is assumed here in order to have a simple "terraform up" when first starting.
    staging = "abc"
  }
}
