
module "vault_demo_vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = "${local.env}-vpc"
  cidr = var.vpc_cidr

  azs             = var.azs
  private_subnets = var.private_subnets
  public_subnets  = var.public_subnets
  enable_nat_gateway = true
  single_nat_gateway = false
  one_nat_gateway_per_az = true
  tags = merge(local.common_tags, {
    "Name" = "${local.env}-vpc"
  })
}

