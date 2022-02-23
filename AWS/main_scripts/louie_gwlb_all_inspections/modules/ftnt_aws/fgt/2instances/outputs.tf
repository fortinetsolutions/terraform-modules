output "fgt1_id" {
  value = aws_instance.fgt1.id
}

output "fgt2_id" {
  value = aws_instance.fgt2.id
}

output "fgt1_eip_public_ip" {
  value = aws_eip.fgt1_eip.public_ip
}

output "fgt2_eip_public_ip" {
  value = aws_eip.fgt2_eip.public_ip
}