resource "random_pet" "test" {
  length = 1
}

locals {
  tags = {
    Name = "${var.tag}-${random_pet.test.id}"
  }
}

variable "tag" {
  default = "boundary-test"
}

variable "aws_vpc_id" {
  type = string
}

variable "aws_public_subnets" {
  type = list(string)
}

variable "aws_private_subnets" {
  type = list(string)
}

variable "aws_ami_owner" {
  type = string
}

# variable "pub_ssh_key_path" {
#   default = "~/.ssh/id_rsa.pub"
# }

# variable "priv_ssh_key_path" {
#   default = ""
# }

variable "num_workers" {
  default = 1
}

variable "num_controllers" {
  default = 1
}

variable "num_targets" {
  default = 1
}

variable "num_vault" {
  default = 1
}

variable "boundary_tls_cert_path" {
  default = "/etc/pki/tls/boundary/boundary.cert"
}

variable "boundary_tls_key_path" {
  default = "/etc/pki/tls/boundary/boundary.key"
}

variable "tls_disabled" {
  default = true
}

variable "kms_type" {
  default = "aws"
}

variable "pub_key" {}

variable "priv_key" {}


### Vault Vars

variable "aws_region" {
  type    = string
  default = "us-east-1"
}

variable "instance_type" {
  type    = string
  default = "t3.small"
}

variable "db_instance_type" {
  type    = string
  default = "t3.small"
}

variable "num_nodes" {
  type    = number
  default = 1
}

variable "db_user" {
  type    = string
  default = "root"
}

variable "db_pass" {
  type    = string
  default = "securePassword1"
}

variable "mysql_dbname" {
  type    = string
  default = "sedemovaultdb"
}

variable "postgres_dbname" {
  type    = string
  default = "tokenizationdb"
}

variable "vault_dl_url" {
  type    = string
  default = "https://releases.hashicorp.com/vault/1.9.0+ent/vault_1.9.0+ent_linux_amd64.zip"
}

variable "vault_license" {
  type    = string
  default = ""
}

variable "consul_tpl_url" {
  type        = string
  description = "Consul template is somewhat legacy, but still works perfectly. It will be migrated to Vault templating in the future."
  default     = "https://releases.hashicorp.com/consul-template/0.27.2/consul-template_0.27.2_linux_amd64.zip"
}

variable "autojoin_key" {
  type    = string
  default = "vault_server_cluster"
}

variable "autojoin_value" {
  type    = string
  default = "vault_raft"
}

variable "prefix" {
  type    = string
  default = "vault-boundary"
}

variable "git_branch" {
  type    = string
  default = "master"
}

variable "owner" {
  type    = string
  default = "se"
}
