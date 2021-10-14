# Output
output "FortiGate-Cluster-IP" {
  value = module.instances.fgt_ha_cluster_ip
}

output "Active-FortiGate-Username" {
  value = module.instances.active_fgt_username
}

output "FortiGate-Password" {
  value = module.instances.active_fgt_password
}
