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

variable "pub_ssh_key_path" {
  default = "~/.ssh/id_rsa.pub"
}

variable "priv_ssh_key_path" {
  default = ""
}

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
