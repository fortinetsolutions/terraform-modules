# Target Instance ID
output "target_instance_id" {
  value       = google_compute_target_instance.default.id
  description = "Target Instance ID"
}
