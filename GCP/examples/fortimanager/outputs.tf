# Output
output "FortiManager-Cluster-IP" {
  value = module.instances.fmg_ip
}

output "FortiManager-Username" {
  value = module.instances.fmg_username
}

output "FortiManager-Password" {
  value = module.instances.fmg_instance_id
}

