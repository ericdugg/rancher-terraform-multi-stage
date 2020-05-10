
resource "tls_private_key" "private_key" {
  algorithm = "RSA"
}

# Change the email to yours
resource "acme_registration" "reg" {
  account_key_pem = tls_private_key.private_key.private_key_pem
  email_address   = "eduggan@oss.co.nz"
}

data "aws_region" "current" {}

resource "acme_certificate" "certificate" {
  account_key_pem           = acme_registration.reg.account_key_pem
  common_name               = aws_route53_record.rancher.name

  dns_challenge {
    provider = "route53"
    config = {
      AWS_HOSTED_ZONE_ID = data.aws_route53_zone.public.zone_id
      AWS_SDK_LOAD_CONFIG = "true"
      AWS_PROFILE = "labterraform"
      AWS_DEFAULT_REGION = data.aws_region.current.name
    }
  }
}


#resource "local_file" "cert" {
#    content     = acme_certificate.certificate.certificate_pem
#    filename = "${path.module}/outputs/rancher.crt.pem"
#}
#resource "local_file" "key" {
#    content     = acme_certificate.certificate.private_key_pem
#    filename = "${path.module}/outputs/rancher.key.pem"
#}

