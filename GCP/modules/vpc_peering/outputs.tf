# VPC Peerings
output "vpc_peerings" {
  value       = google_compute_network_peering.peerings[*].id
  description = "VPC Peerings"
}

output "vpc_peerings_state" {
  value       = google_compute_network_peering.peerings[*].state
  description = "VPC Peerings State"
}
