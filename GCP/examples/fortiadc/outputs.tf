# Output
output "FortiADC-IP" {
  value = module.instances.fadc_ip
}

output "FortiADC-Username" {
  value = "admin"
}

output "FortiADC-Password" {
  value = var.password
}

output "FortiADC-InstanceId" {
  value = module.instances.fadc_instance_id
}
