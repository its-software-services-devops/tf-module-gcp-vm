variable "compute_name" {
  description = "Name of compute engine"
  type        = string
  default     = ""
}

variable "compute_seq" {
  description = "Sequence number of compute engine"
  type        = string
  default     = "00"
}

variable "vm_machine_type" {
  description = "VM compute type"
  type        = string
  default     = "n1-standard-1"
}

variable "vm_machine_zone" {
  description = "VM compute zone"
  type        = string
  default     = "asia-southeast1-b"
}

variable "vm_tags" {
  type    = list(string)
  default = []
}

variable "vm_service_account" {
  description = "VM service account"
  type        = string
  default     = ""
}

variable "vm_deletion_protection" {
  description = "Delete protection"
  type        = bool
  default     = true
}

variable "remote_exec_by_nat_ip" {
  type    = bool
  default = true
}

variable "create_nat_ip" {
  type    = bool
  default = true
}

variable "public_key_file" {
  description = "Path of your SSH public key"
  type        = string
  default     = ""
}

variable "private_key_file" {
  description = "Path of your SSH private key"
  type        = string
  default     = ""
}

variable "ssh_user" {
  description = "SSH user"
  type        = string
  default     = ""
}

variable "boot_disk_image" {
  description = "VM image boot disk"
  type        = string
  default     = ""
}

variable "boot_disk_size" {
  description = "Boot disk size"
  type        = number
  default     = 100
}

variable "startup_script_local_path" {
  description = "Local path of the startup script"
  type        = string
  default     = ""
}

variable "provisioner_local_path" {
  description = "Local path of the provisioner script"
  type        = string
  default     = "dummy.bash"
}

variable "provisioner_remote_path" {
  description = "Remote path of the provisioner script"
  type        = string
  default     = "/tmp"
}

variable "external_disks" {
  type = list(object({    
    index = number #User for hint the for_each loop the current index being used, start with 1
    source  = string
    mode = string
  }))

  default = []
}

variable "network_configs" {
  type = list(object({    
    index                = number #User for hint the for_each loop the current index being used, start with 1
    network              = string
    nat_ip               = string
  }))

  default = []
}
