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

variable "vault_version" {
  type = string
}

source "amazon-ebs" "ubuntu" {
  ami_name      = "${var.unique_name}-aws-vault"
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
      "sudo mkdir -p /etc/pki/tls/vault",
      "sudo mkdir -p /opt/vault",
      "sudo mkdir -p /opt/vault/data",
      "sudo apt-get update",
      "sudo apt-get install -y zip",
      "curl -q --output ~/vault.zip https://releases.hashicorp.com/vault/${var.vault_version}/vault_${var.vault_version}_linux_arm64.zip",
      "unzip vault.zip",
      "sudo rm vault.zip",
      "sudo mv ~/vault /usr/local/bin/vault",
      "sudo chmod 0755 /usr/local/bin/vault",
    ]
  }

  provisioner "file" {
    source = "vault_install.sh"
    destination = "~/install.sh"
  }

  provisioner "shell" {
    inline = [
      "sudo mv ~/install.sh /opt/vault/install.sh",
      "sudo chmod 0755 /opt/vault/install.sh",
    ]
  }
}