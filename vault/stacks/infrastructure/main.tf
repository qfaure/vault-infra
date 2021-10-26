
resource "aws_instance" "vault-transit" {
  ami                         = data.aws_ami.ubuntu.id
  instance_type               = var.instance_type
  subnet_id                   = module.vault_demo_vpc.public_subnets[0]
  key_name                    = var.key_name
  vpc_security_group_ids      = [aws_security_group.vault.id]
  associate_public_ip_address = var.associate_public_ip_address
  private_ip                  = var.vault_transit_private_ip
  iam_instance_profile        = aws_iam_instance_profile.vault_transit.id

  user_data = templatefile("../templates/userdata-vault-transit.tpl", {
    tpl_vault_zip_file     = var.vault_zip_file
    tpl_vault_service_name = "vault-${local.env}"
  })

  tags = merge(local.common_tags, {
    Name = "${local.transit_name}"
  })

  lifecycle {
    ignore_changes = [
      ami,
      tags,
    ]
  }
}

resource "aws_instance" "vault_server" {
  count                       = length(var.vault_server_names)
  ami                         = data.aws_ami.ubuntu.id
  instance_type               = var.instance_type
  subnet_id                   = module.vault_demo_vpc.public_subnets[count.index]
  key_name                    = var.key_name
  vpc_security_group_ids      = [aws_security_group.vault.id]
  associate_public_ip_address = var.associate_public_ip_address
  private_ip                  = var.vault_server_private_ips[count.index]
  iam_instance_profile        = aws_iam_instance_profile.vault_server.id

  user_data = templatefile("../templates/userdata-vault-server.tpl", {
    tpl_vault_node_name          = var.vault_server_names[count.index],
    tpl_vault_storage_path       = "/vault/${var.vault_server_names[count.index]}",
    tpl_vault_zip_file           = var.vault_zip_file,
    tpl_vault_service_name       = "vault-${local.env}",
    tpl_vault_transit_addr       = aws_instance.vault-transit.private_ip
    tpl_vault_node_address_names = zipmap(var.vault_server_private_ips, var.vault_server_names)
  })

  tags = merge(local.common_tags, {
    Name = "${local.vault_name}-${var.vault_server_names[count.index]}"
  })
  lifecycle {
    ignore_changes = [ami, tags]
  }
}