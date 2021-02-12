terraform {
  required_providers {
    google = "3.4.0"
  }
}

locals {
  script_name = basename(var.provisioner_local_path)
  script_path = dirname(var.provisioner_local_path)
}

resource "google_compute_instance" "compute" {
  name         = "${var.compute_name}-${var.compute_seq}"
  machine_type = var.vm_machine_type
  zone         = var.vm_machine_zone
  deletion_protection = var.vm_deletion_protection

  tags = var.vm_tags

  metadata = {
   ssh-keys = "${var.ssh_user}:${file(var.public_key_file)}"
  }

  connection {
    host        = self.network_interface.0.access_config.0.nat_ip
    type        = "ssh"
    user        = var.ssh_user
    private_key = file(var.private_key_file)
    agent       = false
    timeout     = "30s"
  }

  provisioner "file" {
    source      = "${local.script_path}/" #Copy files in the folder to destination
    destination = var.provisioner_remote_path
  }

  provisioner "remote-exec" {
    inline = [
      "chmod 755 ${var.provisioner_remote_path}/${local.script_name}",
      "${var.provisioner_remote_path}/${local.script_name}"
    ]
  }

  boot_disk {
    initialize_params {
      image = var.boot_disk_image
      size = var.boot_disk_size
    }
  }

  dynamic "attached_disk" {
    for_each = [for extd in var.external_disks : {
      index = extd.index - 1
    }]

      content  {
        source = var.external_disks[attached_disk.value.index].source
        mode   = var.external_disks[attached_disk.value.index].mode
      }
  }

  dynamic "network_interface" {
    for_each = [for netw in var.network_configs : {
      index = netw.index - 1
    }]

      content  {
        network = var.network_configs[network_interface.value.index].network

        dynamic "access_config" {
          for_each = var.create_nat_ip ? [1] : []
          content {
            nat_ip = var.network_configs[network_interface.value.index].nat_ip
          }
        }

#          access_config {
#            nat_ip = var.network_configs[network_interface.value.index].nat_ip
#          }
      }
  }

  service_account {
    email = var.vm_service_account
    scopes = ["cloud-platform"]
  }

  allow_stopping_for_update = true
}

