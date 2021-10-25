variable "key_name" {
  description = "The key pair name for connect to EC2"
  default     = ""
  type        = string
}

variable "environment" {
  description = "The name of the environment"
  default     = "dev"
  type        = string
}

variable "aws_region" {
  default     = "eu-west-1"
  description = "the aws region to target"
}

variable "app_name" {
  description = "The name of the app"
  default     = ""
  type        = string
}

variable "owner" {
  description = "The owner of the aws account"
  default     = ""
  type        = string
}

variable "feature_name" {
  description = "The feature name for cost exploration."
  default     = ""
  type        = string
}

variable "vault_transit_private_ip" {
  description = "The private ip of the first Vault node for Auto Unsealing"
  default     = "10.0.101.21"
}


variable "vault_server_names" {
  description = "Names of the Vault nodes that will join the cluster"
  type        = list(string)
  default     = ["leader", "vault_2", "vault_3"]
}

variable "vault_server_private_ips" {
  description = "The private ips of the Vault nodes that will join the cluster"
  type        = list(string)
  default     = ["10.0.101.22", "10.0.102.23", "10.0.103.24"]
}

variable "vault_zip_file" {
  description = "The zip of Vault"
  type        = string
  default     = "https://releases.hashicorp.com/vault/1.8.4/vault_1.8.4_linux_amd64.zip"
}

variable "instance_type" {
  default     = "t2.micro"
  description = "The type of the instance"
  type        = string
}

variable "terraform-base-path" {
  default     = ""
  description = "The folder path of the repository where we work on."
  type        = string
}

variable "associate_public_ip_address" {
  default     = true
  type        = bool
  description = "Give public ip address to aws instance"
}

variable "access_key" {
  default     = ""
  type        = string
  description = "access key to be inject by CI"
}

variable "secret_key" {
  default     = ""
  type        = string
  description = "Secret key to be inject by CI"
}

variable "vpc_cidr" {
  default     = ""
  type        = string
  description = "CIDR block for VPC"
}

variable "azs" {
  default     = ["eu-west-1a", "eu-west-1b", "eu-west-1c"]
  type        = list(string)
  description = "List of AZ where we work on for HA"
}
variable "private_subnets" {
  type        = list(string)
  description = "List of private subnet where we work on"
}
variable "public_subnets" {
  type        = list(string)
  description = "List of public subnet where we work on"
}