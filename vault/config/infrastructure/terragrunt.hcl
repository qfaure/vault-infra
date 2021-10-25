terraform {
  source = "${get_parent_terragrunt_dir()}/../stacks//infrastructure" # double slash (//) is required
}

include {
  path = find_in_parent_folders()
}