resource "tls_private_key" "ssh_key" {
  algorithm = "RSA"
}

resource "local_file" "ssh_key_private" {
  content = tls_private_key.ssh_key.private_key_pem
  filename = pathexpand("${var.ssh_key_path}")
  file_permission = "0660"
}

resource "local_file" "ssh_key_public" {
  content = tls_private_key.ssh_key.public_key_openssh
  filename = pathexpand("${var.ssh_key_path}.pub")
  file_permission = "0644"
}
