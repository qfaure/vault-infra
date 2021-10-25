variable "vault_token" {
  default = ""
  description = "The vault token API"
  type = string
  sensitve = true
}

variable "access_key" {
  default     = ""
  type        = string
  description = "access key to be inject by CI"
    sensitve = true
}

variable "secret_key" {
  default     = ""
  type        = string
  description = "Secret key to be inject by CI"
    sensitve = true
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