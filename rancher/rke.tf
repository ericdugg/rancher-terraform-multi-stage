# RKE resources

# Provision RKE cluster on provided infrastructure
resource "rke_cluster" "rancher_cluster" {
  cluster_name = "rancher-management"

  dynamic nodes {
    for_each = local.node_ips
    iterator = ip_addr
    content {
      address          = ip_addr.value
      user             = local.vm_username
      role             = ["controlplane", "etcd", "worker"]
      ssh_key          = pathexpand(file(local.ssh_key_path))
    }
  }

  authentication {
    strategy = "x509"

    sans = [
      local.api_server_hostname
    ]
  }

  services {
    etcd {
      backup_config {
        interval_hours = 12
        retention      = 6
      }
    }
  }
}

resource "local_file" "kube_cluster_yml" {
  filename = "${path.root}/outputs/kube_config_cluster.yml"
  content = templatefile("${path.module}/files/kube_config_cluster.yml", {
    api_server_url     = local.api_server_url
    rancher_cluster_ca = base64encode(rke_cluster.rancher_cluster.ca_crt)
    rancher_user_cert  = base64encode(rke_cluster.rancher_cluster.client_cert)
    rancher_user_key   = base64encode(rke_cluster.rancher_cluster.client_key)
  })
}
