packer {
  required_plugins {
    amazon = {
      version = ">=0.0.2"
      source  = "github.com/hashicorp/amazon"
    }
  }
}

variable "unique_name" {
  type = string
}

variable "boundary_version" {
  type = string
}

source "amazon-ebs" "ubuntu" {
  ami_name      = "${var.unique_name}-aws-boundary"
  instance_type = "t3.micro"
  region        = "us-east-1"
  source_ami_filter {
    filters = {
      name                = "ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"
      root-device-type    = "ebs"
      virtualization-type = "hvm"
    }
    most_recent = true
    owners      = ["099720109477"]
  }
  ssh_username = "ubuntu"
}

build {
  sources = [
    "source.amazon-ebs.ubuntu"
  ]

  provisioner "shell" {
    execute_command = "/usr/bin/cloud-init status --wait && sudo -E -S sh '{{ .Path }}'"
    inline = [
      "sudo mkdir -p /etc/pki/tls/boundary",
      "sudo mkdir -p /opt/boundary",
      "sudo apt-get update",
      "sudo apt-get install -y zip",
      "curl -q --output ~/boundary.zip https://releases.hashicorp.com/boundary/${var.boundary_version}/boundary_${var.boundary_version}_linux_amd64.zip",
      "unzip boundary.zip",
      "sudo rm boundary.zip",
      "sudo mv ~/boundary /usr/local/bin/boundary",
      "sudo chmod 0755 /usr/local/bin/boundary",
    ]
  }

  provisioner "file" {
    source = "boundary_install.sh"
    destination = "~/install.sh"
  }

  provisioner "shell" {
    inline = [
      "sudo mv ~/install.sh /opt/boundary/install.sh",
      "sudo chmod 0755 /opt/boundary/install.sh",
    ]
  }
}