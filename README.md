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

VSphere uses packer created standard OSS image of Centos 7 (copied from Packer folder).

After a successful terraform run, you'll have `hosts.vsphere` file created in the root working dir, which is the ansible inventory.

### Credentials

For AWS you will need two AWS profiles setup.  The OSS one that should have your AWS credentials to connect to the login account.
``` sh
[profile oss]
output = json
region = ap-southeast-2
```
