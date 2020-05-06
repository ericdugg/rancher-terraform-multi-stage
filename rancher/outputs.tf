output "rancher_admin_password" {
  value       = var.rancher_password
  sensitive   = true
  description = "Password set for Rancher local admin user"
}

output "rancher_url" {
  value       = rancher2_bootstrap.admin.url
  description = "URL at which to reach Rancher"
}

output "rancher_api_url" {
  value       = local.api_server_url
  description = "FQDN of Rancher's Kubernetes API endpoint"
}

output "rancher_token" {
  value       = rancher2_bootstrap.admin.token
  sensitive   = true
  description = "Admin token for Rancher cluster use"
}
