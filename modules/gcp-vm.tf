
resource "google_compute_instance" "compute" {
  metadata_startup_script =  var.startup_script_local_path != "" ? file(var.startup_script_local_path) : ""
  
  name         = var.compute_seq != "" ? "${var.compute_name}-${var.compute_seq}" : var.compute_name
  machine_type = var.vm_machine_type
  zone         = var.vm_machine_zone
  deletion_protection = var.vm_deletion_protection

  tags = var.vm_tags

  lifecycle {
    //ignore_changes = [attached_disk] # We will need this config if use GCE to create K8S worker node
  }

  metadata = {
   ssh-keys  = "${var.ssh_user}:${file(var.public_key_file)}"
   user-data = file(var.user_data_path)
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
        subnetwork = var.network_configs[network_interface.value.index].network

        dynamic "access_config" {
          for_each = var.create_nat_ip ? [1] : []
          content {
            nat_ip = var.network_configs[network_interface.value.index].nat_ip
          }
        }
      }
  }

  service_account {
    email = var.vm_service_account
    scopes = ["cloud-platform"]
  }

  allow_stopping_for_update = true
}

