# locals {
#   priv_ssh_key_real = coalesce(var.priv_ssh_key_path, trimsuffix(var.pub_ssh_key_path, ".pub"))
# }

resource "aws_key_pair" "key_pair" {
  key_name   = "${var.tag}-${random_pet.test.id}"
  public_key = var.pub_key

  tags = local.tags
}

resource "aws_instance" "worker" {
  count                       = var.num_workers
  ami                         = data.aws_ami.boundary.id
  instance_type               = "t3.micro"
  iam_instance_profile        = aws_iam_instance_profile.boundary.name
  subnet_id                   = var.aws_public_subnets[count.index]
  key_name                    = aws_key_pair.key_pair.key_name
  vpc_security_group_ids      = [aws_security_group.worker.id]
  associate_public_ip_address = true

  connection {
    type         = "ssh"
    user         = "ubuntu"
    private_key  = var.priv_key
    host         = self.private_ip
    bastion_host = aws_instance.controller[count.index].public_ip
  }

  provisioner "remote-exec" {
    inline = [
      "echo '${tls_private_key.boundary.private_key_pem}' | sudo tee ${var.boundary_tls_key_path}",
      "echo '${tls_self_signed_cert.boundary.cert_pem}' | sudo tee ${var.boundary_tls_cert_path}",
    ]
  }

  provisioner "file" {
    content = templatefile("${path.module}/install/worker.hcl.tpl", {
      controller_ips         = aws_instance.controller.*.private_ip
      name_suffix            = count.index
      public_ip              = self.public_ip
      private_ip             = self.private_ip
      tls_disabled           = var.tls_disabled
      tls_key_path           = var.boundary_tls_key_path
      tls_cert_path          = var.boundary_tls_cert_path
      kms_type               = var.kms_type
      kms_worker_auth_key_id = aws_kms_key.worker_auth.id
    })
    destination = "~/boundary-worker.hcl"
  }

  provisioner "remote-exec" {
    inline = [
      "sudo mv ~/boundary-worker.hcl /opt/boundary/boundary-worker.hcl",
      "sudo /opt/boundary/./install.sh worker",
    ]
  }

  tags = {
    Name = "${var.tag}-worker-${random_pet.test.id}"
  }

  depends_on = [aws_instance.controller]
}


resource "aws_instance" "controller" {
  count                       = var.num_controllers
  ami                         = data.aws_ami.boundary.id
  instance_type               = "t3.micro"
  iam_instance_profile        = aws_iam_instance_profile.boundary.name
  subnet_id                   = var.aws_public_subnets[count.index]
  key_name                    = aws_key_pair.key_pair.key_name
  vpc_security_group_ids      = [aws_security_group.controller.id]
  associate_public_ip_address = true

  connection {
    type        = "ssh"
    user        = "ubuntu"
    private_key = var.priv_key
    host        = self.public_ip
  }

  provisioner "remote-exec" {
    inline = [
      "echo '${tls_private_key.boundary.private_key_pem}' | sudo tee ${var.boundary_tls_key_path}",
      "echo '${tls_self_signed_cert.boundary.cert_pem}' | sudo tee ${var.boundary_tls_cert_path}",
    ]
  }

  provisioner "file" {
    content = templatefile("${path.module}/install/controller.hcl.tpl", {
      name_suffix            = count.index
      db_endpoint            = aws_db_instance.boundary.endpoint
      private_ip             = self.private_ip
      tls_disabled           = var.tls_disabled
      tls_key_path           = var.boundary_tls_key_path
      tls_cert_path          = var.boundary_tls_cert_path
      kms_type               = var.kms_type
      kms_worker_auth_key_id = aws_kms_key.worker_auth.id
      kms_recovery_key_id    = aws_kms_key.recovery.id
      kms_root_key_id        = aws_kms_key.root.id
    })
    destination = "~/boundary-controller.hcl"
  }

  provisioner "remote-exec" {
    inline = [
      "sudo mv ~/boundary-controller.hcl /opt/boundary/boundary-controller.hcl",
      "sudo chmod 0755 ~/install.sh",
      "sudo /opt/boundary/./install.sh controller"
    ]
  }

  tags = {
    Name = "${var.tag}-controller-${random_pet.test.id}"
  }
}

# WIP Vault cluster
# resource "aws_instance" "vault" {
#   count         = var.num_vault
#   ami           = data.aws_ami.vault.id
#   instance_type = "t3.micro"
#   # iam_instance_profile = aws_iam_instance_profile.vault.name
#   subnet_id = var.aws_public_subnets[count.index]
#   key_name  = aws_key_pair.key_pair.key_name
# }

# Example resource for connecting to through boundary over SSH
resource "aws_instance" "target" {
  count                  = var.num_targets
  ami                    = data.aws_ami.ubuntu.id
  instance_type          = "t3.micro"
  subnet_id              = var.aws_private_subnets[count.index]
  key_name               = aws_key_pair.key_pair.key_name
  vpc_security_group_ids = [aws_security_group.worker.id]

  tags = {
    Name = "${var.tag}-target-${random_pet.test.id}"
  }
}
