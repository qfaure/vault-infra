resource "vault_auth_backend" "userpass" {
  type = "userpass"
}

resource "vault_generic_endpoint" "quentin" {
  path                 = "auth/userpass/users/quentin"
  ignore_absent_fields = var.ignore_absent_fields
  data_json            = <<EOT
  {
    "policies": ["dev-phoenix-app-team"],
    "password": "${var.qf-vault-pwd}"
  }
  EOT
  depends_on           = [vault_auth_backend.userpass]
}

