# Configuration for BYOL Instance using user-data
data "template_file" "setup-nginx-instance" {
  template = file("${path.module}/nginx")
  vars = {
    ufw_allow_nginx = "Nginx HTTP"
  }
}
