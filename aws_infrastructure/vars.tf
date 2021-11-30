variable "aws_vpc_cidr" {
  default = "10.0.0.0/24"
}

variable "aws_region" {
  default = "us-east-1"
}

variable "aws_ami_owner" {}

variable "unique_name" {
  default = "boundary-test"
}

variable "tfe_org" {}

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

variable "kms_key_id" {
  type = string
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
