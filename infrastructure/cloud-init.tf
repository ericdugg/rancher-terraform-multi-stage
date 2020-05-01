data "template_cloudinit_config" "config" {
  gzip          = true
  base64_encode = true

  part {
    content_type = "text/cloud-config"
    content      = "${data.template_file.cloud-config.rendered}"
  }
}

data "template_file" "cloud-config" {
  template = file("${path.module}/files/cloud-config.tpl")
  vars = {
    authorized_key = file(var.ssh_public_key_location)
  }
}
