cluster_addr = ""
api_addr = ""
disable_mlock = true

listener "tcp" {
  address = "${private_ip}:8200"
  tls_cert_file = ""
  tls_key_file = ""
  tls_client_ca_file = ""
}

storage "raft" {
  path = "/opt/vault/data"
  node_id = "vault-${name_suffix}"
  retry_join {
    
  }
}