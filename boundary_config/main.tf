terraform {
  backend "remote" {
    # organization = "<YOUR TFC/E ORG>"
    organization = "jdefrank-org"
    workspaces {
      name = "boundary-config"
    }
  }
}

data "terraform_remote_state" "aws" {
  backend = "remote"
  config = {
    organization = var.tfc_org
    workspaces = {
      name = "aws-infrastructure"
    }
  }
}

module "boundary" {
  source              = "./boundary"
  url                 = "http://${data.terraform_remote_state.aws.outputs.boundary_lb}:9200"
  target_ips          = data.terraform_remote_state.aws.outputs.target_ips
  kms_recovery_key_id = data.terraform_remote_state.aws.outputs.kms_recovery_key_id
}