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
