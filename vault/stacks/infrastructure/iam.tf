## Vault Server IAM Config
resource "aws_iam_instance_profile" "vault_server" {
  name = "${local.vault_name}-instance-profile"
  role = aws_iam_role.vault_server.name
  tags = merge(local.common_tags, {
    "Name" = "${local.vault_name}-profile"
  })
}

resource "aws_iam_role" "vault_server" {
  name               = "${local.vault_name}-role"
  assume_role_policy = data.aws_iam_policy_document.assume_role.json
  tags = merge(local.common_tags, {
    "Name" = "${local.vault_name}-role"
  })
}

resource "aws_iam_role_policy" "vault_server" {
  name   = "${local.vault_name}-role-policy"
  role   = aws_iam_role.vault_server.id
  policy = data.aws_iam_policy_document.vault-server.json
}

# Vault Client IAM Config
resource "aws_iam_instance_profile" "vault_transit" {
  name = "${local.transit_name}-instance-profile"
  role = aws_iam_role.vault_transit.name
  tags = merge(local.common_tags, {
    "Name" = "${local.transit_name}-profile"
  })
}

resource "aws_iam_role" "vault_transit" {
  name               = "${local.transit_name}-role"
  assume_role_policy = data.aws_iam_policy_document.assume_role.json
  tags = merge(local.common_tags, {
    "Name" = "${local.transit_name}-role"
  })
}

resource "aws_iam_role_policy" "vault_transit" {
  name   = "${local.transit_name}-role-policy"
  role   = aws_iam_role.vault_transit.id
  policy = data.aws_iam_policy_document.vault-transit.json
}
