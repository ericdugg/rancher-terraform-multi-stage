#------------------------------------------------------------------------------#
# Data
#------------------------------------------------------------------------------#
data "vsphere_datacenter" "dc" {
  name = "${var.vsphere_dcname}"
}

data "vsphere_compute_cluster" "cluster" {
  name          = "${var.vsphere_cluster_name}"
  datacenter_id = "${data.vsphere_datacenter.dc.id}"
}

data "vsphere_datastore" "datastore" {
  name          = "${var.vsphere_datastore}"
  datacenter_id = "${data.vsphere_datacenter.dc.id}"
}

data "vsphere_storage_policy" "default" {
  name = var.vsphere_storage_policy
}

data "vsphere_network" "network" {
  name          = "${var.vsphere_netname}"
  datacenter_id = "${data.vsphere_datacenter.dc.id}"
}

data "vsphere_virtual_machine" "template" {
  name          = "${var.vsphere_folder}/${var.vsphere_tmplname}"
  datacenter_id = "${data.vsphere_datacenter.dc.id}"
}

#------------------------------------------------------------------------------#
# Resources
#------------------------------------------------------------------------------#
resource "vsphere_virtual_machine" "node" {
  name             = "ED-${var.nameprefix}-node${count.index}"
  annotation       = "rancher"
  count            = var.node_count
  datastore_id     = data.vsphere_datastore.datastore.id
  resource_pool_id = data.vsphere_compute_cluster.cluster.resource_pool_id
  folder           = var.vsphere_folder

  num_cpus = var.node_vm_spec["num_cpus"]
  memory   = var.node_vm_spec["memory"]
  guest_id = data.vsphere_virtual_machine.template.guest_id

  scsi_type         = data.vsphere_virtual_machine.template.scsi_type
  storage_policy_id = data.vsphere_storage_policy.default.id

  network_interface {
    network_id   = data.vsphere_network.network.id
    adapter_type = data.vsphere_virtual_machine.template.network_interface_types[0]
  }

  disk {
    label             = "disk0"
    size              = var.node_vm_spec["disk"] #data.vsphere_virtual_machine.template.disks.0.size
    eagerly_scrub     = data.vsphere_virtual_machine.template.disks.0.eagerly_scrub
    thin_provisioned  = data.vsphere_virtual_machine.template.disks.0.thin_provisioned
    storage_policy_id = data.vsphere_storage_policy.default.id
  }

  clone {
    template_uuid = data.vsphere_virtual_machine.template.id

    customize {
      linux_options {
        host_name = "node${count.index}"
        domain    = var.domain
        time_zone = var.time_zone
      }
      network_interface {
        ipv4_address = var.vms_ips["node${count.index}"]
        ipv4_netmask = var.vms_ips["ipv4_netmask"]
      }
      dns_suffix_list = [var.domain]
      dns_server_list = var.dns_servers
      ipv4_gateway    = var.ipv4_gateway
      timeout         = 30
    }
  }

}

resource "vsphere_virtual_machine" "lb" {
  count            = var.lb_count
  name             = "ED-${var.nameprefix}-lb${count.index}"
  annotation       = "rancher"
  datastore_id     = data.vsphere_datastore.datastore.id
  resource_pool_id = data.vsphere_compute_cluster.cluster.resource_pool_id
  folder           = var.vsphere_folder

  num_cpus = var.lb_vm_spec["num_cpus"]
  memory   = var.lb_vm_spec["memory"]
  guest_id = data.vsphere_virtual_machine.template.guest_id

  scsi_type         = data.vsphere_virtual_machine.template.scsi_type
  storage_policy_id = data.vsphere_storage_policy.default.id

  network_interface {
    network_id   = data.vsphere_network.network.id
    adapter_type = data.vsphere_virtual_machine.template.network_interface_types[0]
  }

  disk {
    label             = "disk0"
    size              = var.lb_vm_spec["disk"] # data.vsphere_virtual_machine.template.disks.0.size
    eagerly_scrub     = data.vsphere_virtual_machine.template.disks.0.eagerly_scrub
    thin_provisioned  = data.vsphere_virtual_machine.template.disks.0.thin_provisioned
    storage_policy_id = data.vsphere_storage_policy.default.id
  }

  clone {
    template_uuid = data.vsphere_virtual_machine.template.id

    customize {
      linux_options {
        host_name = "lb${count.index}"
        domain    = var.domain
        time_zone = var.time_zone
      }
      network_interface {
        ipv4_address = var.vms_ips["lb${count.index}"]
        ipv4_netmask = var.vms_ips["ipv4_netmask"]
      }
      dns_suffix_list = [var.domain]
      dns_server_list = var.dns_servers
      ipv4_gateway    = var.ipv4_gateway
      timeout         = 30
    }
  }

}
