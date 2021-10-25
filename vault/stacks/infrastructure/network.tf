
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

