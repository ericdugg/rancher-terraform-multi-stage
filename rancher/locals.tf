locals {
  rancher_server_url  = "https://${data.terraform_remote_state.infrastructure.outputs.rancher_dns_name}"
  rancher_server_hostname = data.terraform_remote_state.infrastructure.outputs.rancher_dns_name
  api_server_url      = "https://${data.terraform_remote_state.infrastructure.outputs.rancher_api_dns_name}"
  api_server_hostname = data.terraform_remote_state.infrastructure.outputs.rancher_api_dns_name
  node_ips            = tolist("${data.terraform_remote_state.infrastructure.outputs.node_ips}")
  rancher_version     = var.rancher_version
  ssh_key_path        = data.terraform_remote_state.infrastructure.outputs.ssh_key_path
  vm_username         = data.terraform_remote_state.infrastructure.outputs.vm_username
}
