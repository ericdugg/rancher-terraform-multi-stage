resource "null_resource" "ansible_provision" {
  provisioner "local-exec" {
    command = "ansible-playbook ansible/rancher.yml --vault-password-file ../vault.pwd -i ../hosts.vsphere"
  }
}
