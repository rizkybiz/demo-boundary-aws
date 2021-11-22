

data "aws_ami" "boundary" {
  most_recent = true

  filter {
    name   = "name"
    values = ["${var.tag}-aws-boundary"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["${var.aws_ami_owner}"]
}

data "aws_ami" "vault" {
  most_recent = true

  filter {
    name   = "name"
    values = ["${var.tag}-aws-vault"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["${var.aws_ami_owner}"]
}

data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}