data "template_file" "vault" {
  template = file("${path.module}/files/vault.tmpl")

  vars = {
    password = var.ansible_vault_password
  }
}
  
data "template_file" "nodes" {
  template = file("${path.module}/files/host_item.tmpl")
  count    = length(vsphere_virtual_machine.node)

  vars = {
    host    = "node${count.index}.${var.domain}"
    host_ip = element(vsphere_virtual_machine.node.*.default_ip_address, count.index)
  }
}

data "template_file" "lbr" {
  template = file("${path.module}/files/host_item.tmpl")
  count    = length(vsphere_virtual_machine.lbr)

  vars = {
    host    = "lbr${count.index}.${var.domain}"
    host_ip = element(vsphere_virtual_machine.lbr.*.default_ip_address, count.index)
  }
}

data "template_file" "lba" {
  template = file("${path.module}/files/host_item.tmpl")
  count    = length(vsphere_virtual_machine.lba)

  vars = {
    host    = "lba${count.index}.${var.domain}"
    host_ip = element(vsphere_virtual_machine.lba.*.default_ip_address, count.index)
  }
}

data "template_file" "inventory" {
  template = file("${path.module}/files/hosts.tmpl")

  vars = {
    ansible_user    = var.vm_username
    ssh_private_key = var.ssh_key_path
    nodes           = "${join("\n", data.template_file.nodes.*.rendered)}"
    lbr             = "${join("\n", data.template_file.lbr.*.rendered)}"
    lba             = "${join("\n", data.template_file.lba.*.rendered)}"
  }
}

resource "local_file" "vault_pwd_file" {
  content         = data.template_file.vault.rendered
  filename        = "${path.module}/../vault.pwd"
  file_permission = "0640"
}

resource "local_file" "host_vars_file_lbr" {
  count           = length(vsphere_virtual_machine.lbr)
  content         = "keepalived_priority: ${101 - count.index}\n"
  filename        = "${path.module}/../provision/ansible/host_vars/lbr${count.index}.${var.domain}"
  file_permission = "0664"
}

resource "local_file" "host_vars_file_lba" {
  count           = length(vsphere_virtual_machine.lba)
  content         = "keepalived_priority: ${101 - count.index}\n"
  filename        = "${path.module}/../provision/ansible/host_vars/lba${count.index}.${var.domain}"
  file_permission = "0664"
}

resource "local_file" "inventory" {
  content         = data.template_file.inventory.rendered
  filename        = "${path.module}/../hosts.vsphere"
  file_permission = "0664"

  provisioner "remote-exec" {
    inline = ["echo 'Hello World'"]

    connection {
      type        = "ssh"
      host        = element(vsphere_virtual_machine.node.*.default_ip_address, 1)
      user        = var.vm_username
      password    = var.vm_username_password
    }
  }

  provisioner "local-exec" {
    command = "ansible-playbook ansible/ssh-sudo.yml -i ../hosts.vsphere --extra-vars 'ansible_sudo_pass=${var.vm_username_password} ansible_ssh_pass=${var.vm_username_password}'"
  }
}
