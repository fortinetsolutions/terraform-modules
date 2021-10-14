# Output
output "Fortigate-IP" {
  value = "${google_compute_instance.fgt_instance.network_interface.0.access_config.0.nat_ip}"
}
