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
  vaule = aws_db_instance.vault-postgres.endpoint
}
