# HA-Cluster-IP
output "fmg_ip" {
  value = "${google_compute_instance.fmg_instance.network_interface.0.access_config.0.nat_ip}"
}

# FortiManager-Username
output "fmg_username" {
  value = "admin"
}

# FortiManager-Password
output "fmg_password" {
  value = var.password
}
