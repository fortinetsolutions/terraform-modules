output "web_id" {
  value = aws_instance.web.id
}

output "web_ip" {
  value = aws_network_interface.eni0.private_ips
}

output "web_eip" {
  value = aws_eip.eip.public_ip
}