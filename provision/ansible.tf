data "template_file" "nodes" {
  template = file("${path.module}/files/host_item.tmpl")
  count    = length(data.terraform_remote_state.infrastructure.node_ips)

  vars = {
    host    = "node${count.index}.${data.terraform_remote_state.infrastructure.domain}"
    host_ip = element(data.terraform_remote_state.infrastructure.node_ips, count.index)
  }
}

data "template_file" "lbs" {
  template = file("${path.module}/files/host_item.tmpl")
  count    = length(data.terraform_remote_state.infrastructure.lbs_ips)

  vars = {
    host    = "lb${count.index}.${data.terraform_remote_state.infrastructure.domain}"
    host_ip = element(data.terraform_remote_state.infrastructure.lbs_ips, count.index)
  }
}

data "template_file" "inventory" {
  template = file("${path.module}/files/hosts.tmpl")

  vars = {
    ansible_user    = data.terraform_remote_state.infrastructure.vm_username
    ssh_private_key = data.terraform_remote_state.infrastructure.ssh_key_path
    nodes           = "${join("\n", data.template_file.nodes.*.rendered)}"
    lbs             = "${join("\n", data.template_file.lbs.*.rendered)}"
  }
}

resource "local_file" host_vars_file_lb" {
  count           = length(data.terraform_remote_state.infrastructure.lbs_ips
  content         = "keepalived_priority: ${101 - count.index}"
  filename        = "${path.module}/ansible/host_vars/lb${count.index}.${data.terraform_remote_state.infrastructure.domain}"
  file_permission = "0664"
}

resource "local_file" "inventory" {
  content         = data.template_file.inventory.rendered
  filename        = "${path.module}/ansible/hosts.vsphere"
  file_permission = "0664"

  provisioner "local-exec" {
    command = "ansible-playbook -i local_file.inventory.filename ansible/rancher.yml"
  }
}
