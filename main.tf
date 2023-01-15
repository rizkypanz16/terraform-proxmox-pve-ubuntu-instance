## membuat instance dengan ubuntu-cloud-img di proxmox pve

terraform {
  required_version = ">=1.0.0" 
  required_providers {
    proxmox = {
      source = "telmate/proxmox"
      version = "2.9.11"
    }
  }
}

#mendefinisikan provider
provider "proxmox" {
  pm_api_url = "https://<proxmox_server_url>:8006/api2/json"		# masukan url pve server dengan FQDN dan tambahkan /api2/json dibagian akhir
  
  pm_api_token_id = "<username>@pam!<tokenId>"		# api_token_id diisi sesuai user yang telah terdaftar
  pm_api_token_secret = "<token_secret>"			# token_secret diisi sesuai token_secret user yang telah diisi diatas

  pm_tls_insecure = true		# tls_insecure disetting true jika ssl tidak dapat diverifikasi
  pm_debug = true				# untuk melihat debug history saat provisioning berlangsung
}

# membuat ubuntu instance
resource "proxmox_vm_qemu" "ubuntu" {
  count = 1 									# jumlah vm yang akan dibuat
  name = "panz-openstack-${count.index + 1}" 	# nama vm ditambah dengan count.index yang didapatkan dari jumlah instance yang dibuat

  target_node = "pve" 							# arget_node diisi dengan Nodename pada proxmox cluster

  
  clone = var.template_name		# isi dengan template server yang telah dibuat dan data diambil dari variable file contoh disini menggunakan "ubuntu-2004-cloudinit-template"

  # konfigurasi virtual-machine
  agent = 1
  os_type = "cloud-init"
  cores = 2							# jumlah core cpu
  sockets = 1
  cpu = "host"
  memory = 5000						# jumlah memory yang akan digunakan
  scsihw = "virtio-scsi-pci"
  bootdisk = "scsi0"

  # konfigurasi disk untuk virtual machine
  disk {
    slot = 0
    size = "64G"					# kapasitas disk yang akan digunakan
    type = "scsi"
    storage = "local-lvm"
    iothread = 1
  }
   
   
  # konfigurasi jaringan yang akan digunakan menggunakan virtio vmbr0
  network {
    model = "virtio"
    bridge = "vmbr0"
  }

  # tidak yakin persis untuk apa ini. mungkin sesuatu tentang alamat MAC dan mengabaikan perubahan jaringan selama masa pakai VM
  lifecycle {
    ignore_changes = [
      network,
    ]
  }
  
   # ${count.index + 1} menambahkan teks di akhir alamat ip untuk multiple instance
   # dalam hal ini, karena kami hanya menambahkan satu VM, IP akan
   # menjadi 10.98.1.91 sejak count.index dimulai dari 0. beginilah cara Anda membuat
   # beberapa VM dan memiliki IP yang ditetapkan untuk masing-masing (.91, .92, .93, dll.)

 ipconfig0 = "ip=192.168.7.111/24,gw=192.168.7.1"
  
  # sshkey disetting untuk dapat terkoneksi dengan instance dan data diambil dari variable file
  sshkeys = <<EOF
  ${var.ssh_key}
  EOF
}
