# Output
output "FortiTester-IP" {
  value = module.instances.fts_ip
}

output "FortiTester-Username" {
  value = module.instances.fts_username
}

output "FortiTester-Password" {
  value = ""
}

output "FortiTester-Instance-ID" {
  value = module.instances.fts_instance_id
}
