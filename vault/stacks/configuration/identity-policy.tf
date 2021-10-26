
/////////////POLICY ////////////////
resource "vault_policy" "phoenix_app_secret_admin" {
  name = "admin-phoenix-app-team"

  policy = <<EOT
  path "production/*" {
    capabilities = ["read", "list", "update"]
    }
EOT
}


resource "vault_policy" "phoenix_app_secret_dev" {
  name = "dev-phoenix-app-team"

  policy = <<EOT
  path "production/*" {
    capabilities = ["read", "list"]
    }
EOT
}

resource "vault_identity_entity" "phoenix_app_admin" {
  name = "admin-phoenix-app"
  policies  = ["admin-phoenix-app-team"]
  metadata = {
    env     = "production"
    service = "project_secrets"
  }
}

resource "vault_identity_entity" "phoenix_app_dev" {
  name = "dev-phoenix-app"
  policies  = ["dev-phoenix-app-team"]
  metadata = {
    env     = "production"
    service = "project_secrets"
  }
}