# RKE resources

# Provision RKE cluster on provided infrastructure
resource "rke_cluster" "rancher_cluster" {
  cluster_name = "rancher-management"

  dynamic nodes {
    for_each = local.node_ips
    iterator = "ip_addr"
    content {
      address          = ip_addr.value
      user             = var.vm_username
      role             = ["controlplane", "etcd", "worker"]
      ssh_key          = tls_private_key.ssh_key.private_key_pem
    }
  }

  services_etcd {
    backup_config {
      interval_hours = 12
      retention      = 6
    }
  }
}
