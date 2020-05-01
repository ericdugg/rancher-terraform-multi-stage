# This data source looks up the public DNS zone
data "aws_route53_zone" "public" {
  name         = "${var.domain}."
  private_zone = false
}
  
# Standard route53 DNS record for "rancher" pointing to vmware host
resource "aws_route53_record" "rancher" {
  zone_id = data.aws_route53_zone.public.zone_id
  name    = "rancher.${data.aws_route53_zone.public.name}"
  type    = "A"
  ttl     = "300"
  records = [ var.lb_floating_ip ]
}

resource "aws_route53_record" "lb" {
  zone_id = data.aws_route53_zone.public.zone_id
  count   = length(vsphere_virtual_machine.lb)
  name    = "lb${count.index}.${data.aws_route53_zone.public.name}"
  type    = "A"
  ttl     = "300"
  records = [ vsphere_virtual_machine.lb[count.index].default_ip_address ]
}

resource "aws_route53_record" "node" {
  zone_id = data.aws_route53_zone.public.zone_id
  count   = length(vsphere_virtual_machine.node)
  name    = "node${count.index}.${data.aws_route53_zone.public.name}"
  type    = "A"
  ttl     = "300"
  records = [ vsphere_virtual_machine.node[count.index].default_ip_address ]
}
