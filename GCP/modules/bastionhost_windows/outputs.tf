# Bastion-Host-IP
output "bastion_host_ip" {
  value = "${google_compute_instance.bastion_instance.network_interface.0.access_config.0.nat_ip}"
}
