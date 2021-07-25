output "instance_nat_ip_addr" {
  value = var.create_nat_ip ? element(concat(google_compute_instance.compute.*.network_interface.0.access_config.0.nat_ip, tolist([])), 0) : ""

  #value = google_compute_instance.compute.*.network_interface.0.access_config.0.nat_ip
}

output "instance_private_ip_addr" {
  #value = google_compute_instance.compute.*.network_interface.0.network_ip
  value = element(concat(google_compute_instance.compute.*.network_interface.0.network_ip, tolist([])), 0)
}

output "instance_id" {
  value = google_compute_instance.compute.instance_id
}

output "id" {
  value = google_compute_instance.compute.id
}