# Output
output "FortiAnalyzer-IP" {
  value = module.instances.faz_ip
}

output "FortiAnalyzer-Username" {
  value = module.instances.faz_username
}

output "FortiAnalyzer-Password" {
  value = module.instances.faz_instance_id
}

