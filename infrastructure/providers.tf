# Change this after testing to the non-staging URL.
provider "acme" {
  server_url = "https://acme-staging-v02.api.letsencrypt.org/directory"
}

provider "aws" {
  profile = var.aws_profile
  region  = var.aws_region
  assume_role {
    role_arn = var.aws_role_arn
  }
}

provider "vsphere" {
  user = var.vsphere_user
  password       = var.vsphere_password
  vsphere_server = var.vsphere_server

  # If you have a self-signed cert
  allow_unverified_ssl = true
}
