locals {
  rancher_server_url = "https://${terraform_remote_state.infrastructure.rancher_dns_name}"
  node_ips           = terraform_remote_state.infrastructure.node_ips
}
