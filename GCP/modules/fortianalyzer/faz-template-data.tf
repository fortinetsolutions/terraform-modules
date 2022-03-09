# Configuration for FAZ Instance using faz-template-data
data "template_file" "setup-faz-instance" {
  template = file("${path.module}/faz-template")
  vars = {
    faz_password = var.password
  }
}
