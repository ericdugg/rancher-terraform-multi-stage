# Create a Rancher HA Cluster using Terraform

This repo contains 3 folders with Terraform Configurations used to build a Rancher HA Cluster. 
They are meant to be run in this order:
- infrastructure
- provision
- rancher

## infrastructure
Use `terraform.tfvars.example` as a template.
Updated `backend.tf` with your AWS details for state.
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

VSphere set up is based on a Centos 7 image.

After a successful terraform run, you'll have `hosts.vsphere` file created in the root working dir, which is the ansible inventory. Also under the root working dir will be a `vault.pwd` file with your vault password. You will also have host vars files for each of the load balancers created under `provision/ansible/host_vars` matching the FQDN for each load balancer. This sets the `keepalived_priority` variable for each pair of the HA load balancers for use by the ansible playbooks called by the Terraform provision code. You will also have a ssh config created under `~/.ssh/config` setting up access to the servers using ssh keys.

### Credentials

For AWS you will need two AWS profiles setup.  The main one that should have your AWS credentials to connect to the login account.
``` sh
[profile <main profile name>]
output = json
region = <region>
```
You will also need a profile in your .aws/config that uses the above source profile, and defines a role_arn, so that the ACME route53 provider can connect to AWS.
``` sh
[profile <sub profile name>]
role_arn = <role for terraform>
source_profile = <main profile name>
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

### ACME Cert
The provider for ACME is configured to use the staging URL.

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
Use `terraform.tfvars.example` as a template.
Run `terraform apply` which provisions only one resouce:
- null_resource.ansible_provision

It is a null resource which uses a local provisioner to run the playbook under ansible called `rancher.yml`. This configures the load balancers with nginx (lba load balancers listen on 443 and 6443 and load balance to the node servers on port 6443 and lbr load balancers listen on 443 and 80 and load balance to port 80 and 443 on the load balancers). It also configures keepalived with the floating IP for rancher on the lbr load balancers and for kube-apiserver on the lba load balancers. On the nodes it installs docker, configures kernel settings, modules, and ssh configuration required for a high availablity installation. It also updates the OS CA store with the ACME fakelerootx1.pem and fakeleintermediatex1.pem certs so the ACME staging cert will be trusted.

Look at `ansible/group_vars/*` for configuration.

## rancher
Use `terraform.tfvars.example` as a template.
Run `terraform apply` which provisions the RKE cluster, cattle-system namespace, secrets for the ACME CERT and CA, Rancher application installed using HELM, and bootstraps the cluster setting the admin password and server-url.

This relies on output variables from the infrastructure folder state and a `terraform_remote_state` data object is configured using the appropriate S3 configuration.

A `kube_config_cluster.yml` file is written to `outputs` and you can use this to connect with kubectl by setting your `KUBECONFIG` ENV VAR to this. It is pointing at the kube-apiserver load balanced DNS name for the server setting. 

### Certs
Since we are bringing our own Certs from ACME which are staging Certs we need to create a secret for the Cert. This needs to be a concatanation of the cert itself and the intermediate cert used to sign it. We also need a secret for the CA Cert. When configuring the rancher install using HELM we set `ingress.tls.source` to `secret` and `privateCA` to `true`.

### Rke
This uses a community provider for rke and version 1.0.0-rc5. It needs to be under `~/.terraform.d/plugins` and named `terraform-provider-rke_v1.0.0-rc5`. The github repo is `https://github.com/rancher/terraform-provider-rke`.
