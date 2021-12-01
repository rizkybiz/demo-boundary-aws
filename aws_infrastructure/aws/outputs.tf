output "boundary_lb" {
  value = aws_lb.controller.dns_name
}

output "target_ips" {
  value = aws_instance.target.*.private_ip
}

output "kms_recovery_key_id" {
  value = aws_kms_key.recovery.id
}

output "vault_postgres_endpoint" {
  value = aws_db_instance.vault-postgres.endpoint
}

output "vault_node_dns_endpoint" {
  value = aws_instance.vault-server[0].public_dns
}

output "vault_node_ip_endpoint" {
  value = aws_instance.vault-server[0].public_ip
}
