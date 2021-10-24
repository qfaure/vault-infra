provider "aws" {
   region     = "eu-west-1"
    access_key = "AKIAV4BZS3EKXPSYK6F2"
  secret_key = "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"
   
}

data "aws_instance" "leader" {

  filter {
    name   = "tag:Name"
    values = ["*-leader"]
  }
}

output "leader_ip"{
  value = data.aws_instance.leader.public_ip
}


variable "vault_token" {
  default = ""
}
provider "vault" {
    token = var.vault_token
    address = "http://${data.aws_instance.leader.public_ip}:8200"
  # Configuration options
}

resource "vault_generic_secret" "test_secret" {
    path      = "kv/project_secrets"
    data_json = <<EOT
    {
    "my_secret": "${random_password.test_secret.result}"
    }
    EOT
}

resource "random_password" "test_secret" {
    length = 32
    special = true
}


resource "vault_mount" "kvv2-example" {
  path        = "version2-example"
  type        = "kv-v2"
  description = "This is an example KV Version 2 secret engine mount"
}

