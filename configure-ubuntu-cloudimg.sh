#!/bin/bash

wget http://cloud-images.ubuntu.com/releases/jammy/release/ubuntu-22.04-server-cloudimg-amd64.img
apt update -y
apt install -y libguestfs-tools
virt-customize -a focal-server-cloudimg-amd64.img --install qemu-guest-agent
virt-customize -a focal-server-cloudimg-amd64.img --root-password password:ijinmasuk
qm create 9002 --name "ubuntu-2004-cloudinit-template" --memory 2048 --cores 2 --net0 virtio,bridge=vmbr0
qm importdisk 9002 focal-server-cloudimg-amd64.img local-lvm
qm set 9002 --scsihw virtio-scsi-pci --scsi0 local-lvm:vm-9002-disk-0
qm set 9002 --boot c --bootdisk scsi0
qm set 9002 --ide2 local-lvm:cloudinit
qm set 9002 --agent enabled=1
qm template 9002