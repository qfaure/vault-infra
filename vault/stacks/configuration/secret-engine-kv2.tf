resource "vault_mount" "production" {
  path        = "production"
  type        = "kv-v2"
  description = "production secret engine."
}


resource "vault_generic_secret" "production_secret" {
    path      = "production/project_secrets"
    data_json = <<EOT
    {
    "my_secret": "${random_password.production_secret.result}"
    }
    EOT
}

resource "random_password" "production_secret" {
    length = 32
    special = true
}

