resource "kubernetes_namespace" "cattle-system" {
  metadata {
    name = "cattle-system"
  }

  depends_on = [
    rke_cluster.rancher_cluster,
  ]
}

resource "kubernetes_secret" "tls-rancher-ingress" {
  metadata {
    name = "tls-rancher-ingress"
    namespace = "cattle-system"
  }

  data = {
    "tls.crt" = local.cert
    "tls.key" = local.key
  }

  type = "kubernetes.io/tls"

  depends_on = [
    kubernetes_namespace.cattle-system,
  ]
}

resource "kubernetes_secret" "tls-ca" {
  metadata {
    name = "tls-ca"
    namespace = "cattle-system"
  }

  data = {
    "cacerts.pem" = file("${path.module}/files/cacerts.pem")
  }

  depends_on = [
    kubernetes_namespace.cattle-system,
  ]
}
