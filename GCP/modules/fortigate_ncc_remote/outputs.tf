# HA-Cluster-IP
output "fgt_cluster_ip" {
  value = google_compute_instance.fgt_remote_instance.network_interface.0.access_config.0.nat_ip
}

# FortiGate-SelfLink
output "fgt_self_link" {
  value = google_compute_instance.fgt_remote_instance.self_link
}

# Internal IP of the nic0
output "fgt_internal_ip_nic0" {
  value = google_compute_instance.fgt_remote_instance.network_interface.0.network_ip
}

# Internal IP of the nic0
output "fgt_internal_ip_nic1" {
  value = google_compute_instance.fgt_remote_instance.network_interface.1.network_ip
}

# FortiGate-Username
output "fgt_username" {
  value = "admin"
}

# FortiGate-Password
output "fgt_password" {
  value = var.password
}
