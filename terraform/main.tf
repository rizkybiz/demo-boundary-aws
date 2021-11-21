terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "3.65.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

data "aws_availability_zones" "available" {}

module "vpc" {
  source               = "terraform-aws-modules/vpc/aws"
  version              = "3.11.0"
  cidr                 = var.aws_vpc_cidr
  azs                  = data.aws_availability_zones.available.names
  private_subnets      = cidrsubnets(cidrsubnet(var.aws_vpc_cidr, 1, 1))
  public_subnets       = cidrsubnets(cidrsubnet(var.aws_vpc_cidr, 1, 2))
  enable_nat_gateway   = true
  single_nat_gateway   = true
  enable_dns_hostnames = true
}

module "aws" {
  source              = "./aws"
  tag                 = var.unique_name
  pub_ssh_key_path    = var.pub_ssh_key_path
  priv_ssh_key_path   = var.priv_ssh_key_path
  aws_vpc_id          = module.vpc.vpc_id
  aws_public_subnets  = module.vpc.public_subnets
  aws_private_subnets = module.vpc.private_subnets
  aws_ami_owner       = var.aws_ami_owner
}

module "boundary" {
  source              = "./boundary"
  url                 = "http://${module.aws.boundary_lb}:9200"
  target_ips          = module.aws.target_ips
  kms_recovery_key_id = module.aws.kms_recovery_key_id
}
