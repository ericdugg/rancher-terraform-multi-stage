# install rancher
resource "helm_release" "rancher" {
  name       = "rancher"
  repository = data.helm_repository.rancher_stable.metadata[0].name
  chart      = var.rancher_chart
  version    = "v${local.rancher_version}"
  namespace  = "cattle-system"

  set {
    name  = "hostname"
    value = local.rancher_server_hostname
  }

  set {
    name  = "ingress.tls.source"
    value = "secret"
  }

  set {
    name  = "privateCA"
    value = "true"
  }
}

resource "null_resource" "wait_for_rancher" {
  provisioner "local-exec" {
    command = <<EOF
while [ "$${subject}" != "*  subject: CN=$${RANCHER_HOSTNAME}" ]; do
    subject=$(curl -vk -m 2 "https://$${RANCHER_HOSTNAME}/ping" 2>&1 | grep "subject:")
    echo "Cert Subject Response: $${subject}"
    if [ "$${subject}" != "*  subject: CN=$${RANCHER_HOSTNAME}" ]; then
      sleep 10
    fi
done
while [ "$${resp}" != "pong" ]; do
    resp=$(curl -sSk -m 2 "https://$${RANCHER_HOSTNAME}/ping")
    echo "Rancher Response: $${resp}"
    if [ "$${resp}" != "pong" ]; then
      sleep 10
    fi
done
EOF


    environment = {
      RANCHER_HOSTNAME = local.rancher_server_hostname
      TF_LINK          = helm_release.rancher.name
    }
  }
}

resource "rancher2_bootstrap" "admin" {
  provider = rancher2.bootstrap

  depends_on = [null_resource.wait_for_rancher]

  current_password = var.rancher_current_password
  password         = var.rancher_password
}
