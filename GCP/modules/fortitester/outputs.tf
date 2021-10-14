# FortiTester-IP
output "fts_ip" {
  value = google_compute_instance.fts_instance.network_interface.0.access_config.0.nat_ip
}

# FortiTester-Username
output "fts_username" {
  value = "admin"
}

# FortiTester-InstanceId
output "fts_instance_id" {
  value = google_compute_instance.fts_instance.instance_id
}
