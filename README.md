## Provision ubuntu instance in Proxmox PVE using Terraform

### Steps to provision ubuntu pve instance with terraform :

- Clone repository
```
git clone https://github.com/rizkypanz16/terraform-proxmox-pve-ubuntu-instance.git
```
- Change the configuration below with the aws configuration you have made 
```
<proxmox_server_url>
<username>@pam!<tokenId>
<token_secret>
<ssh_key>
```
- Plan - Preview changes before applying.
```
terraform plan
```
- Apply - Provision reproducible infrastructure.
```
terraform apply
```
