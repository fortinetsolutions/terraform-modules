# Configuration for FMG Instance using fmg-template-data
data "template_file" "setup-fmg-instance" {
  template = "${file("${path.module}/fmg-template")}"
  vars = {
    fmg_password = var.password
  }
}
