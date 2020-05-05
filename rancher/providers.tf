provider "aws" {
  profile = var.aws_profile
  region  = var.aws_region
  assume_role {
    role_arn = var.aws_arn_role
  }
}

# RKE provider - community plugin
provider "rke" {
  version = "1.0.0-rc5"
}

# Helm provider
provider "helm" {
  version = "~> 1.0"

  kubernetes {
    host = rke_cluster.rancher_cluster.api_server_url

    client_certificate     = rke_cluster.rancher_cluster.client_cert
    client_key             = rke_cluster.rancher_cluster.client_key
    cluster_ca_certificate = rke_cluster.rancher_cluster.ca_crt

    load_config_file = false
  }
}

# Rancher2 bootstrapping provider
provider "rancher2" {
  version = "~> 1.7"

  alias = "bootstrap"

  api_url  = local.rancher_server_url
  bootstrap = true
}

# Rancher2 administration provider
provider "rancher2" {
  version = "~> 1.7"

  alias = "admin"

  api_url  = local.rancher_server_url
  token_key = rancher2_bootstrap.admin.token
}
