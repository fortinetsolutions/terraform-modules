# Configuration for FortiADC Instance using fadc-template-data
data "template_file" "setup-fadc-instance" {
  template = file("${path.module}/fadc-template")
  vars = {
    fadc_password = var.password
  }
}
