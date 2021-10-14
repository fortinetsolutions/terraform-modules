# Nginx IP
output "nginx_ip" {
  value = google_compute_instance.nginx_instance.network_interface.0.access_config.0.nat_ip
}

output "nginx_internal_ip" {
  value = google_compute_instance.nginx_instance.network_interface.0.network_ip
}