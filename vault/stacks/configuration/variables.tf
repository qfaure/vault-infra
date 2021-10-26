variable "vault_token" {
  default = ""
  description = "The vault token API"
  type = string
  sensitive = true
}

variable "access_key" {
  default     = ""
  type        = string
  description = "access key to be inject by CI"
    sensitive = true
}

variable "secret_key" {
  default     = ""
  type        = string
  description = "Secret key to be inject by CI"
  sensitive = true
}

variable "environment" {
  description = "The name of the environment"
  default     = "dev"
  type        = string
}

variable "aws_region" {
  default     = "eu-west-1"
  description = "the aws region to target"
}

variable "qf-vault-pwd" {
  default     = ""
  type        = string
  description = "Secret key to be inject by CI"
  sensitive = true
}


variable "ignore_absent_fields" {
  default = true
  type = bool
  description = "ignore mandatory fields"
}

variable "access_list_readonly" {
  description = "list of access in readonly secret in production"
  type = list(object({
    vault-policy = string,
    vault-entity = string
  }))
  default = []
}

variable "access_list_admin" {
  description = "list of access in ADMIN secret in production"
  type = list(object({
    vault-policy = string,
    vault-entity = string
  }))
  default = []
}
