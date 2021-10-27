# Output
output "External_LoadBalancer_Ip_Address" {
  value = google_compute_forwarding_rule.external_load_balancer.ip_address
}

output "Bastion-Host-IP" {
  value = module.bastionhost_windows.bastion_host_ip
}
