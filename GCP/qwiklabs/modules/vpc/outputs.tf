# All VPCs
output "vpc_networks" {
  value       = google_compute_network.vpc[*].name
  description = "VPCs"
}

output "vpc_networks_selflink" {
  value       = google_compute_network.vpc[*].self_link
  description = "All VPCs Selflinks"
}