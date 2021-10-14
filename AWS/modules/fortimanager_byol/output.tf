
output "instance_id" {
  value = aws_instance.fortimanager.id
}

output "network_public_interface_id" {
  value = aws_network_interface.public_eni.id
}
