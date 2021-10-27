# HA-Cluster-IP
output "fgt_ha_cluster_ip" {
  value = google_compute_instance.fgt_spoke_instance.network_interface.0.access_config.0.nat_ip
}

# FortiGate-SelfLink
output "fgt_self_link" {
  value = google_compute_instance.fgt_spoke_instance.self_link
}

# Internal IP of the nic0
output "fgt_ha_internal_ip" {
  value = google_compute_instance.fgt_spoke_instance.network_interface.0.network_ip
}

# FortiGate-Username
output "active_fgt_username" {
  value = "admin"
}

# FortiGate-Password
output "active_fgt_password" {
  value = var.password
}
