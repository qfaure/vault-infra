locals {
  env          = var.environment
  vault_name   = "${local.env}-vault-cluster"
  transit_name = "${local.env}-vault-transit"

  common_tags = {
    "managed-by"          = "Terraform"
    "feature-name"        = "vault-demo"
    "environment"         = var.environment
    "owner"               = var.owner
    "component-type"      = "infrastructure"
    "terraform-base-path" = var.terraform-base-path
  }
}

