# Run this at the beginning : export GOOGLE_CREDENTIALS="D:/dev/keys/its-artifact-commons-6eb8e8c315b3.json"

terraform {
  required_providers {
    google = "3.76.0"
  }

  backend "gcs" {
    bucket  = "evermed-devops-prod-terraform-state"
    prefix  = "tf-module-gcp-vm"
  }  
}

provider "google" {  
  project     = "evermed-devops-prod"
  region      = "asia-southeast1"
}

resource "google_compute_disk" "disk00" {
  name  = "terraform-vm-module-test"
  type  = "pd-ssd"
  zone  = "asia-southeast1-b"
  physical_block_size_bytes = 4096
}

module "compute-gcp-vm-00" {
  source          = "../modules"
  compute_name    = "terraform-vm-module-test-output"
  compute_seq     = ""
  vm_tags         = ["openvpn"]
  #vm_service_account = "devops-cicd@its-artifact-commons.iam.gserviceaccount.com"
  boot_disk_image  =  "projects/centos-cloud/global/images/centos-7-v20200910" #"projects/cos-cloud/global/images/cos-beta-89-16108-0-69"
  public_key_file  = "D:/id_rsa.pub"
  private_key_file = "D:/id_rsa"
  vm_machine_type  = "n1-standard-1"
  vm_machine_zone  = "asia-southeast1-b"
  vm_deletion_protection = false
  provisioner_remote_path = "/home/cicd"
  provisioner_local_path = "scripts/provisioner.bash"
  startup_script_local_path = "scripts/startup.bash"
  ssh_user         = "cicd"
  create_nat_ip    = true
  remote_exec_by_nat_ip = true
  external_disks   = [{index = 1, source = google_compute_disk.disk00.id, mode = "READ_WRITE"}]
  network_configs  = [{index = 1, network = "projects/evermed-infra-prod/regions/asia-southeast1/subnetworks/devops-nonprod-vpn", nat_ip = ""}] #google_compute_address.static.address
}
