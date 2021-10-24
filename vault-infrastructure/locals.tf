locals {
    env = var.environment
    vault_name = "${local.env}-vault-cluster"
    transit_name = "${local.env}-vault-transit"
}

