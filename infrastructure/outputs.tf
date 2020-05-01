output "node_ips" {
  value       = ["${vsphere_virtual_machine.node.*.default_ip_address}"]
  description = "The IP addresses of the nodes"
}

output "lbs_ips" {
  value       = ["${vsphere_virtual_machine.lb.*.default_ip_address}"]
  description = "The IP addresses of the load balancers"
}

output "domain" {
  value       = var.domain
  description = "domain var exported for use by other stages"
}

output "vm_username" {
  value       = var.vm_username
  description = "vm_username var exported for use by other stages"
}

output "ssh_key_path" {
  value       = var.ssh_key_path
  description = "ssh_key_path var exported for use by other stages"
}

output "cert" {
  value       = acme_certificate.certificate.certificate_pem
  description = "The certificate PEM"
}

output "cert_key" {
  value       = acme_certificate.certificate.private_key_pem
  description = "The private key PEM for the cert"
}

output "rancher_dns_name" {
  value       = aws_route53_record.rancher.fqdn
  description = "The fqdn to connect to rancher"
}
