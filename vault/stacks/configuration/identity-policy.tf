
/////////////POLICY ////////////////
resource "vault_policy" "phoenix_app_secret_admin" {
  count  = length(local.access_list_admin)
  name   = local.access_list_admin[count.index]["vault-policy"]
  policy = <<EOT
    path "production/*" {
      capabilities = ["read", "list", "update"]
      }
  EOT
}

resource "vault_identity_entity" "admin" {
  count    = length(local.access_list_admin)
  name     = local.access_list_admin[count.index]["vault-entity"]
  policies = [local.access_list_admin[count.index]["vault-policy"]]
  metadata = {
    env     = "production"
    service = "phoenix"
  }
}

//cidr_block = local.ip_whitelist[count.index]["cidr"]
//comment    = local.ip_whitelist[count.index]["comment"]


resource "vault_policy" "readonly" {
  count  = length(local.access_list_readonly)
  name   = local.access_list_readonly[count.index]["vault-policy"]
  policy = <<EOT
  path "production/*" {
    capabilities = ["read", "list"]
    }
EOT
}

resource "vault_identity_entity" "readonly" {
  count    = length(local.access_list_readonly)
  name     = local.access_list_readonly[count.index]["vault-entity"]
  policies = [local.access_list_readonly[count.index]["vault-policy"]]
  metadata = {
    env     = "production"
    service = "project_secrets"
  }
}



