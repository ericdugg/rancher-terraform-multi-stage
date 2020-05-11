# Create a Rancher HA Cluster using Terraform

This repo contains 3 folders with Terraform Configurations used to build a Rancher HA Cluster. 
They are meant to be run in this order:
- infrastructure
- provision
- rancher

## Infrastructure
Use `terraform.tfvars.example` as a template.
Run `terraform apply` to provision infrastructure.
Which includes, for AWS:
- `node` Route53 records
- `lba` Route53 records
- `lbr` Route53 records
- `api.rancher.` Route53 record pointing at the Keepalived floating IP for the kube-apiserver
- `rancher.` Route53 record pointing at the Keepalived floating IP for the rancher application

for ACME:
- a certificate for rancher for accessing the application

for Vsphere:
- 2 load balancers for kube-apiserver
- 2 load balancers for rancher application
- 3 nodes for the rke cluster where the rancher application is deployed
- various network and template related resources



