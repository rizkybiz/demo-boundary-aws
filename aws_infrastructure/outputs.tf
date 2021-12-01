output "target_ips" {
  value = module.aws.target_ips
}

output "kms_recovery_key_id" {
  value = module.aws.kms_recovery_key_id
}

output "boundary_lb" {
  value = module.aws.boundary_lb
}

output "vault_postgres_endpoint" {
  value = module.aws.vault_postgres_endpoint
}

output "vault_node_dns_endpoint" {
  value = module.aws.vault_node_dns_endpoint
}

output "vault_node_ip_endpoint" {
  value = module.aws.vault_node_ip_endpoint
}