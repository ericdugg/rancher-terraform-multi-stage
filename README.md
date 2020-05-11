# Create a Rancher HA Cluster using Terraform

This repo contains 3 folders with Terraform Configurations used to build a Rancher HA Cluster. 
They are meant to be run in this order:
- infrastructure
- provision
- rancher

## infrastructure
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

After a successful terraform run, you'll have `hosts.vsphere` file created in the root working dir, which is the ansible inventory. Also under the root working dir will be a `vault.pwd` file with your vault password. You will also have host vars files for each of the load balancers created under `provision/ansible/host_vars` matching the FQDN for each load balancer. This sets the `keepalived_priority` variable for each pair of the HA load balancers for use by the ansible playbooks called by the Terraform provision code. You will also have a ssh config created under `~/.ssh/config` setting up access to the servers using ssh keys.

### Credentials

For AWS you will need two AWS profiles setup.  The OSS one that should have your AWS credentials to connect to the login account.
``` sh
[profile oss]
output = json
region = ap-southeast-2
```
You will also need a profile in your .aws/config that uses the oss source profile, and defines the following role_arn, so that the ACME route53 provider can connect to AWS.
``` sh
[profile labterraform]
role_arn = arn:aws:iam::085032814280:role/OSS_Terraform_no_MFA
source_profile = oss
```
For VSphere you'll need a username / password to use the API. There is a script to configure the ENV VAR with your username and password.

``` sh
source set_vmware_pwd.sh
```

### Ansible
The terraform code uses a local provisioner to run a playbook under ansible called `ssh-sudo.yml`. This generates a ssh keypair. It copies the public key onto all the infrastructure servers and writes the private key to `~/.ssh/<project>-id_rsa`.

### Vault
The vault password set in the `vault.pwd` file in the root directory is needed for unlocking some vault protected variables used by Ansible under `provision/ansible`. These variables are:
- `vault_haproxy_admin_user`
- `vault_haproxy_admin_password`

Nginx is used for the load balancer rather than HAProxy so these variables are not actually used. As they are defined under the ansible structure a vault password is still required. It is using the default value set for `ansible_vault_password` in `variables.tf`. If you wanted to change to your own vault password if you decided to use HAProxy, you need to remove the vault encrypted files under `provision/ansible/group_vars/lbr and lba`. Then recreate the vault encrypted files with your updated vault password and set it in `terraform.tfvars`.

### Outputs
A number of variables are output for use by the terraform configuration under the `rancher` folder. It uses the state from `infrastructure` by setting up a `terraform_remote_state` s3 backend pointing at it. The variables exported are:

- node_ips
- domain
- vm_username
- ssh_key_path
- cert
- cert_key
- rancher_dns_name
- rancher_api_dns_name

## provision

