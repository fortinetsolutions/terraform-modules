output "fgt_login_info" {
  value = <<-FGTLOGIN
  # fgt username: admin
  # fgt1 login url: https://${aws_eip.fgt_eip.public_ip}
  FGTLOGIN
}
output "linux_login_info" {
  value = <<-WEBLOGIN
  # swan instance SSH info: ssh -i ${var.keypair} ubuntu@${aws_eip.swan_eip.public_ip}
  WEBLOGIN
}