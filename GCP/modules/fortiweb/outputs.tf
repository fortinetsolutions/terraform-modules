# FWEB-IP
output "fweb_ip" {
  value = google_compute_instance.fweb_instance.network_interface.0.access_config.0.nat_ip
}

# FortiWeb-Username
output "fweb_username" {
  value = "admin"
}

# FortiWeb-Password
output "fweb_password" {
  value = var.password
}

# FortiWeb-InstanceId
output "fweb_instance_id" {
  value = google_compute_instance.fweb_instance.instance_id
}
