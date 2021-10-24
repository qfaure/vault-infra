
variable "aws_region" {
  default     = "eu-west-1"
  description = "the aws region to target"
}

# All resources will be tagged with this
variable "environment_name" {
  default = "raft-demo"
}

variable "vault_transit_private_ip" {
  description = "The private ip of the first Vault node for Auto Unsealing"
  default     = "10.0.101.21"
}


variable "vault_server_names" {
  description = "Names of the Vault nodes that will join the cluster"
  type        = list(string)
  default     = [ "leader", "vault_2", "vault_3"]
}

variable "vault_server_private_ips" {
  description = "The private ips of the Vault nodes that will join the cluster"
  # @see https://docs.aws.amazon.com/vpc/latest/userguide/VPC_Subnets.html
  type    = list(string)
  default = ["10.0.101.22", "10.0.101.23", "10.0.101.24"]
}


# URL for Vault OSS binary
variable "vault_zip_file" {
  default = "https://releases.hashicorp.com/vault/1.6.0/vault_1.6.0_linux_amd64.zip"
}

# Instance size
variable "instance_type" {
  default = "t2.micro"
}

# SSH key name to access EC2 instances (should already exist) in the AWS Region
variable "key_name" {
}
variable "environment" {}
