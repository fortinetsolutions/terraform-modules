# HA-Cluster-IP
output "fmg_ip" {
  value = google_compute_instance.fmg_instance.network_interface.0.access_config.0.nat_ip
}

# FortiManager-Username
output "fmg_username" {
  value = "admin"
}

# FortiManager-Password
output "fmg_password" {
  value = var.password
}

# FortiManager-InstanceId
output "fmg_instance_id" {
  value = google_compute_instance.fmg_instance.instance_id
}
