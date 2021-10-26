locals {
  # Warning: this name is used in remote_state S3 bucket name. Do not forget to change it if you are copy/pasting this project
  project_name = "vault-infra"
  aws_region   = "eu-west-1"
  environment = get_env("TF_VAR_ENV", "dev")
}

remote_state {
  backend = "s3"
  config = {
    bucket         = "demo-qf-infra-${local.environment}-tfstate"
    key            = "${path_relative_to_include()}/terraform.tfstate"
    region         = local.aws_region
    encrypt        = true
    dynamodb_table = "demo-qf-infra-${local.environment}-tfstatelock"
  }
}

# Configure root level variables that all resources can inherit
# We do not use .tfvar files because of this issue: https://github.com/gruntwork-io/terragrunt/issues/873
# Solution: we use .vars.yml files. Under the hood, Terragruntnetwork_feature_name generates TF_VAR_xxx environment variables from them
# Source: https://github.com/gruntwork-io/terragrunt-infrastructure-live-example/blob/master/prod/terragrunt.hcl
#
# Files are evaluated/overriden into this order (the later takes predecence):
# 0. Inputs defined in this file (main terragrunt.hcl)
# 1. /live/common.vars.yml
# 2. /live/**/common.vars.yml
# 3. /live/<TF_VAR_env>.vars.yml
# 4. /live/**/<TF_VAR_env>.vars.yml
#
inputs = merge(
  {
    project_name : local.project_name,
    aws_region : local.aws_region,
    environment : local.environment
  },
  yamldecode(
    fileexists("${find_in_parent_folders("common.vars.yml")}") ? file("${find_in_parent_folders("common.vars.yml")}") : "{}",
  ),
  yamldecode(fileexists("${get_terragrunt_dir()}/common.vars.yml") ? file("${get_terragrunt_dir()}/common.vars.yml") : "{}"),
  yamldecode(
    fileexists("${find_in_parent_folders("${local.environment}.yml")}") ? file("${find_in_parent_folders("${local.environment}.yml")}") : "{}",
  ),
  yamldecode(fileexists("${get_terragrunt_dir()}/${local.environment}.yml") ? file("${get_terragrunt_dir()}/${local.environment}.yml") : "{}")
)