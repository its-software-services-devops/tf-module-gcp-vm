# Run : 'gcloud auth login' then 'gcloud auth application-default login'

terraform {
  required_providers {
    google = "4.10.0"
  }

  backend "gcs" {
    bucket  = "its-terraform-states"
    prefix  = "tf-module-gcp-vm"
  }  
}

provider "google" {  
  project     = "its-artifact-commons"
  region      = "asia-southeast1"
}

resource "google_compute_disk" "disk00" {
  name  = "terraform-vm-module-test"
  type  = "pd-ssd"
  zone  = "asia-southeast1-b"
  physical_block_size_bytes = 4096
  size = 200
}

module "compute-gcp-vm-00" {
  source          = "../modules"
  compute_name    = "terraform-vm-module-test-output"
  compute_seq     = ""
  vm_tags         = ["unittest-terraform"]
  #vm_service_account = "devops-cicd@its-artifact-commons.iam.gserviceaccount.com"
  boot_disk_image  =  "projects/cos-cloud/global/images/cos-93-16623-102-8"
  public_key_file  = "D:/id_rsa.pub"
  vm_machine_type  = "n1-standard-1"
  vm_machine_zone  = "asia-southeast1-b"
  vm_deletion_protection = false
  startup_script_local_path = "scripts/startup.bash"
  ssh_user         = "cicd"
  create_nat_ip    = false
  user_data_path   = "scripts/cloud-init.yaml"
  external_disks   = [{index = 1, source = google_compute_disk.disk00.id, mode = "READ_WRITE"}]
  network_configs  = [{index = 1, network = "default", nat_ip = ""}] #google_compute_address.static.address
}
