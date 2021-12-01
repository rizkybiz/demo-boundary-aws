terraform {
  required_providers {
    tfe = {
      source  = "hashicorp/tfe"
      version = "0.26.1"
    }
  }
}

locals {
  raw_json          = jsondecode(file("~/.terraform.d/credentials.tfrc.json"))
  token             = local.raw_json.credentials["app.terraform.io"].token
  pub_ssh_key       = file(var.pub_ssh_key_path)
  priv_ssh_key_real = coalesce(var.priv_ssh_key_path, trimsuffix(var.pub_ssh_key_path, ".pub"))
  priv_ssh_key      = file(local.priv_ssh_key_real)
}

provider "tfe" {
  token = local.token
}

resource "tfe_workspace" "aws-infra" {
  name = "aws-infrastructure"
  # terraform_version = var.tf_version
  organization = var.org_name
  remote_state_consumer_ids = [
    tfe_workspace.boundary-config.id
  ]
}

resource "tfe_workspace" "boundary-config" {
  name = "boundary-config"
  # terraform_version = var.tf_version
  organization = var.org_name
}

resource "tfe_run_trigger" "run-trigger" {
  workspace_id  = tfe_workspace.boundary-config.id
  sourceable_id = tfe_workspace.aws-infra.id
}

resource "tfe_variable" "pub-key" {
  key          = "pub_key"
  value        = local.pub_ssh_key
  category     = "terraform"
  workspace_id = tfe_workspace.aws-infra.id
  description  = "Public SSH key"
  sensitive    = false
}

resource "tfe_variable" "priv-key" {
  key          = "priv_key"
  value        = local.priv_ssh_key
  category     = "terraform"
  workspace_id = tfe_workspace.aws-infra.id
  description  = "Private SSH key"
  sensitive    = true
}