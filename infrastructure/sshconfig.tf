data "template_file" "lbr-ssh-config" {
  template = file("${path.module}/files/ssh_config_item.tmpl")
  count    = length(vsphere_virtual_machine.lbr)

  vars = {
    host_short      = "lbr${count.index}"
    host_ip         = element(vsphere_virtual_machine.lbr.*.default_ip_address, count.index)
    vm_user         = var.vm_username
    ssh_key_private = var.ssh_key_path
  }
}

data "template_file" "lba-ssh-config" {
  template = file("${path.module}/files/ssh_config_item.tmpl")
  count    = length(vsphere_virtual_machine.lba)

  vars = {
    host_short      = "lba${count.index}"
    host_ip         = element(vsphere_virtual_machine.lba.*.default_ip_address, count.index)
    vm_user         = var.vm_username
    ssh_key_private = var.ssh_key_path
  }
}

data "template_file" "nodes-ssh-config" {
  template = file("${path.module}/files/ssh_config_item.tmpl")
  count    = length(vsphere_virtual_machine.node)

  vars = {
    host_short      = "node${count.index}"
    host_ip         = element(vsphere_virtual_machine.node.*.default_ip_address, count.index)
    vm_user         = var.vm_username
    ssh_key_private = var.ssh_key_path
  }
}

data "template_file" "ssh-config" {
  template = file("${path.module}/files/ssh_config.tmpl")
  
  vars = {
    lbr_config   = "${join("\n", data.template_file.lbr-ssh-config.*.rendered)}"
    lba_config   = "${join("\n", data.template_file.lba-ssh-config.*.rendered)}"
    nodes_config = "${join("\n", data.template_file.nodes-ssh-config.*.rendered)}"
  }
}

resource "local_file" "ssh-config" {
  content         = data.template_file.ssh-config.rendered
  filename        = pathexpand("${var.ssh_config_path}")
  file_permission = "0644"
}
