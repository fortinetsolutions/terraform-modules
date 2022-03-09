# FAZ-IP
output "faz_ip" {
  value = google_compute_instance.faz_instance.network_interface.0.access_config.0.nat_ip
}

# FortiAnalyzer-Username
output "faz_username" {
  value = "admin"
}

# FortiAnalyzer-Password
output "faz_password" {
  value = var.password
}

# FortiAnalyzer-InstanceId
output "faz_instance_id" {
  value = google_compute_instance.faz_instance.instance_id
}
