resource "vault_mount" "production" {
  path        = "production"
  type        = "kv-v2"
  description = "production secret engine."
}


resource "vault_generic_secret" "phoenix_app_secret" {
  path       = "production/phoenix-app"
  data_json  = <<EOT
    {
    "my_secret": "${random_password.phoenix_app_secret.result}"
    }
    EOT
  depends_on = [vault_mount.production]
}

resource "random_password" "phoenix_app_secret" {
  length  = 32
  special = true
}

