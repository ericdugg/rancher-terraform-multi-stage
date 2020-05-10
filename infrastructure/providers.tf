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
  version = "~> 1.5"
  # Use environmental variables VSPHERE_USER
  # and VSPHERE_PASSWORD for user and password
  vsphere_server = var.vsphere_server

  # If you have a self-signed cert
  allow_unverified_ssl = true
}
