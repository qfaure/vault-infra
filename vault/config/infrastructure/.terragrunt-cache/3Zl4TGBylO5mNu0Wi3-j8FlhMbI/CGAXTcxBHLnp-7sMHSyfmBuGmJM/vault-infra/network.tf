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
module "vault_demo_vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = "${local.env}-vpc"
  cidr = var.vpc_cidr

  azs             = var.azs
  private_subnets = var.private_subnets
  public_subnets  = var.public_subnets

  tags = merge(local.common_tags, {
    "Name" = "${local.env}-vpc"
  })
}

