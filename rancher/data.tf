data "helm_repository" "rancher_stable" {
  name = "rancher-stable"
  url  = "https://releases.rancher.com/server-charts/stable/"
}
