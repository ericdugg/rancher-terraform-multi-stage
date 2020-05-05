resource "null_resource" "ansible_provision" {
  provisioner "local-exec" {
    command = "ansible-playbook ansible/rancher.yml -i ../hosts.vsphere"
  }
}
