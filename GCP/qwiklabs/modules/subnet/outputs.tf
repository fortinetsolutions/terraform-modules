# Public Subnet Gateway Address
output "public_subnet_gateway_address" {
  value = google_compute_subnetwork.subnet[0].gateway_address
}

# Public Subnet Gateway Address
output "subnet_gateway_address" {
  value = google_compute_subnetwork.subnet[*].gateway_address
}

# All Subnets
output "subnets" {
  value       = google_compute_subnetwork.subnet[*].name
  description = "All Subnets"
}

output "subnets_selflink" {
  value       = google_compute_subnetwork.subnet[*].self_link
  description = "All Subnets"
}