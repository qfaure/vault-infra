

provider "aws" {
  region     = var.aws_region
  access_key = var.access_key
  secret_key = var.secret_key

}

provider "vault" {
  token   = var.vault_token
  address = "http://${data.aws_instance.leader.public_ip}:8200"
}


terraform {
  backend "s3" {}
  required_version = ">= 0.15"
}


