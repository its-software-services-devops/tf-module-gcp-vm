output "internal-ip" {
  value = module.compute-gcp-vm-00.instance_private_ip_addr
}

output "nat-ip" {
  value = module.compute-gcp-vm-00.instance_nat_ip_addr
}

output "instance-id" {
  value = module.compute-gcp-vm-00.instance_id
}