# Configuration for FGT Instance using data
data "template_file" "setup-fgt-instance" {
  template = file("${path.module}/fgt-template")
  vars = {
    admin_port   = var.admin_port
    fgt_password = var.password
  }
}
