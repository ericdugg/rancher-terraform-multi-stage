data "template_file" "nodes" {
  template = file("files/host_item.tmpl")
  count    = length(data.terraform_remote_state.infrastructure.node_ips)

  vars = {
    host    = "node${count.index}.${var.domain}"
    host_ip = element(vsphere_virtual_machine.node.*.default_ip_address, count.index)
  }
}

data "template_file" "lbs" {
  template = file("files/host_item.tmpl")
  count    = length(vsphere_virtual_machine.lb)

  vars = {
    host    = "lb${count.index}.${var.domain}"
    host_ip = element(vsphere_virtual_machine.lb.*.default_ip_address, count.index)
  }
}

data "template_file" "inventory" {
  template = file("files/hosts.tmpl")

  vars = {
    ansible_user    = var.vm_username
    ssh_private_key = var.ssh_key_path
    nodes           = "${join("\n", data.template_file.nodes.*.rendered)}"
    lbs             = "${join("\n", data.template_file.lbs.*.rendered)}"
  }
}

resource "local_file" host_vars_file_lb" {
  count           = length(vsphere_virtual_machine.lb)
  content         = "keepalived_priority: ${101 - count.index}"
  filename        = "ansible/host_vars/lb${count.index}.${var.domain}"
  file_permission = "0664"
}

resource "local_file" "inventory" {
  content         = data.template_file.inventory.rendered
  filename        = "ansible/hosts.vsphere"
  file_permission = "0664"

  provisioner "remote-exec {
    inline = ["echo 'Hello World'"]

    connection {
      type        = "ssh"
      host        = vsphere_virtual_machine.node.0.default_ip_address
      user        = var.vm_username
      private_key = tls_private_key.ssh_key.private_key_pem
    }
  }

  provisioner "local-exec" {
    command = "ansible-playbook -i local_file.inventory.filename ansible/rancher.yml"
  }
}

resource "null_resource" "ansible_provision_wait" {
  depends_on = ["local_file.inventory"]

  provisioner "local-exec" {
    command = "ssh -i ${var.ssh_key_path} -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null ${var.vm_username}@${vsphere_virtual_machine.node.0.default_ip_address} 'while true; do if [ ! -f /etc/systemd/system/firewall.service ]; then sleep 20; else break; fi; done; sleep 20'"
  }
 
  triggers = {
    vm_instance_ids = "${join{",", vsphere_virtual_machine.node.*.id)}"
  }
}
