# Output
output "External-IP" {
  value = module.static_ip.static_ip
}

output "FortiGate-IP" {
  value = module.instances.fgt_ip
}

output "Active-FortiGate-Username" {
  value = module.instances.active_fgt_username
}

output "FortiGate-Password" {
  value = module.instances.active_fgt_password
}
