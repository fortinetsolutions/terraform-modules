# FADC-IP
output "fadc_ip" {
  value = google_compute_instance.fadc_instance.network_interface.0.access_config.0.nat_ip
}

# FortiADC-Username
output "fadc_username" {
  value = "admin"
}

# FortiADC-Password
output "fadc_password" {
  value = var.password
}

# FortiADC-InstanceId
output "fadc_instance_id" {
  value = google_compute_instance.fadc_instance.instance_id
}
