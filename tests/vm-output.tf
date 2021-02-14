output "internal-ip" {
  value = module.compute-gcp-vm-00.instance_provate_ip_addr
}

output "nat-ip" {
  value = module.compute-gcp-vm-00.instance_nat_ip_addr
}