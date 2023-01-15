# mendefinisikan ssh-key
variable "ssh_key" {
  default = "ssh-rsa <ssh_key> rsa-key-20221128"
}

# mendefinisikan proxmox server fqdn
variable "proxmox_host" {
    default = "<proxmox_pve_server>"		# dapat diubah sesuai url proxmox server anda
}

# mendefinisikan nama vm template
variable "template_name" {
    default = "ubuntu-2004-cloudinit-template"		# template dibuat dengan langkah pada file configure-ubuntu-cloudimg.sh
}
