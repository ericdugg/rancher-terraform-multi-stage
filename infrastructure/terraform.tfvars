vsphere_user           = "eduggan@oss.co.nz"
vsphere_server         = "vc03av.oss.co.nz"
vsphere_dcname         = "OSS-Test"
vsphere_cluster_name   = "OSS-Test"
vsphere_datastore      = "PureM10-VVOL"
vsphere_netname        = "Test"
vsphere_tmplname       = "centos7-cloud-init"
vsphere_folder         = "ED-rancher"
vsphere_storage_policy = "VVol No Requirements Policy"

# SSH Key path
ssh_key_path           = "~/.ssh/rancher-id_rsa"

# SSH config path
ssh_config_path        ="~/.ssh/config"

lb_floating_ip         = "192.168.210.242"
# AWS Provider
aws_profile            = "oss"
aws_region             = "ap-southeast-2"
aws_role_arn           = "arn:aws:iam::085032814280:role/OSS_Terraform_no_MFA"
vm_username            = "centos"

# VM Specs Config
lb_vm_spec = {
  num_cpus = 1
  memory   = 2048 # Mb
  disk     = 50 # Gb
}

node_vm_spec = {
  num_cpus = 2
  memory   = 8192 # Mb
  disk     = 50 # Gb
}

# VM Network Config
domain         = "lab.oss.nz"
ipv4_gateway   = "192.168.210.254"
dns_servers    = ["192.168.213.4", "192.168.214.4"]
time_zone      = "Pacific/Auckland"

vms_ips = {
  lb0          = "192.168.210.240",
  lb1          = "192.168.210.241",
  node0        = "192.168.210.243",
  node1        = "192.168.210.244",
  node2        = "192.168.210.245",
  ipv4_netmask = 24,
}
