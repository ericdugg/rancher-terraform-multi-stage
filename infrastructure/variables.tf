variable aws_profile {
  description = "The AWS profile name set in the credentials file"
}

variable aws_region {
  description = "The AWS region"
}

variable aws_role_arn {
  description ="The ARN of the role to assume"
}

variable vsphere_user {
  description = "User to use with VMWare"
}

variable vsphere_password {
  description = "Password to use with VMWare"
}

variable vsphere_server {
  description = "vSphere Server"
}

variable vsphere_dcname {
  description = "Name of Datacenter in vSphere"
}

variable vsphere_cluster_name {
  description = "vSphere Compute Cluster Name"
}
variable vsphere_datastore {
  description = "Name of Datastore in vSphere"
}

variable vsphere_netname {
  description = "Name of Network in vSphere"
}

variable vsphere_tmplname {
  description = "Template name to use"
}

variable vsphere_folder {
  description = "Folder to put a VM"
}

variable "vsphere_storage_policy" {
  description = "VSphere Storage Policy"
}

variable domain {
  description = "OSC Domain"
}

variable ssh_key_path {
  description = "Path to ssh private key"
}

variable ssh_config_path {
  description = "Path to your ssh config"
}

variable "nameprefix" {
  description = "Project name prefix"
  default     = "rancher"
}

variable "lb_floating_ip" {
  description = "Keepalived floating IP that dns name resolves to"
}

variable "vms_ips" {
  description = "VMs static IPs to use"
  type        = map(string)
}

variable "dns_servers" {
  description = "DNS Servers for static net configuration"
  type        = list(string)
}

variable "ipv4_gateway" {
  description = "Gateway for static net configuration"
}

variable "time_zone" {
  description = "Time Zone"
}

variable "lb_vm_spec" {
  description = "Specs for load balancer VMs"
  type        = map(string)
}

variable "lb_count" {
  description = "Number of load balancers"
  default     = 2
}

variable "node_vm_spec" {
  description = "Specs for node VMs"
  type        = map(string)
}

variable "node_count" {
  description = "Number of nodes"
  default     = 3
}

variable "vm_username" {
  type        = string
  description = "Username used for SSH access to the VMs"
  default     = "centos"
}

variable "vm_username_password" {
  type        = string
  description = "Password for username used for SSH access to the VMs"
  default     = "centos"
}

variable "ansible_vault_password" {
  type        = string
  description = "Password for ansible vault"
}
