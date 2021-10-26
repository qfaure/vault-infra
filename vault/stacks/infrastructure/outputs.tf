
output "leader" {
  value = aws_instance.vault_server[0].public_ip
}

output "endpoints" {
  value = <<EOF
  transit_vault (${aws_instance.vault-transit.public_ip}) | internal: (${aws_instance.vault-transit.private_ip})
    - Initialized and unsealed.
    - The root token creates a transit key that enables the other Vaults to auto-unseal.
    - Does not join the High-Availability (HA) cluster.

  leader (${aws_instance.vault_server[0].public_ip}) | internal: (${aws_instance.vault_server[0].private_ip})
    - Initialized and unsealed.
    - The root token and recovery key is stored in /tmp/key.json.
    - K/V-V2 secret engine enabled and secret stored.
    - Leader of HA cluster

    $ ssh -l ubuntu ${aws_instance.vault_server[0].public_ip} -i ${var.key_name}.pem

    # Root token:
    $ ssh -l ubuntu ${aws_instance.vault_server[0].public_ip} -i ${var.key_name}.pem "cat ~/root_token"
    # Recovery key:
    $ ssh -l ubuntu ${aws_instance.vault_server[0].public_ip} -i ${var.key_name}.pem "cat ~/recovery_key"

  vault_2 (${aws_instance.vault_server[1].public_ip}) | internal: (${aws_instance.vault_server[1].private_ip})
    - Started
    - You will join it to cluster started by leader

    $ ssh -l ubuntu ${aws_instance.vault_server[1].public_ip} -i ${var.key_name}.pem

  vault_3 (${aws_instance.vault_server[2].public_ip}) | internal: (${aws_instance.vault_server[2].private_ip})
    - Started
    - You will join it to cluster started by leader

    $ ssh -l ubuntu ${aws_instance.vault_server[2].public_ip} -i ${var.key_name}.pem

EOF
}
