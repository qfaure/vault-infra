resource "vault_auth_backend" "userpass" {
  type = "userpass"
}


resource "vault_generic_endpoint" "quentin" {
  depends_on           = [vault_auth_backend.userpass]
  path                 = "auth/userpass/users/quentin"
  ignore_absent_fields = true

  data_json = <<EOT
{
  "policies": ["dev-phoenix-app-team"],
  "password": "${var.qf-vault-pwd}"
}
EOT
}

