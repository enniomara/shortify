variable "authorizer_configuration" {
  type = object({
    issuer   = string
    audience = list(string)
  })
  default = null

  validation {
    condition     = var.authorizer_configuration != null ? length(var.authorizer_configuration.issuer) > 0 : true
    error_message = "Issuer must be non-0 length"
  }

  validation {
    condition     = var.authorizer_configuration != null ? length(var.authorizer_configuration.audience) > 0 : true
    error_message = "Audience must not be empty"
  }
}
