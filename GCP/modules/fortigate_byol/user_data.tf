# Configuration for BYOL Instance using user-data
data "template_file" "setup-byol-instance" {
  template = file("${path.module}/byol")
  vars = {
    fgt_password   = var.password
    public_gateway = var.public_subnet_gateway
    clusterip      = "cluster-ip-${var.random_string}"
    internalroute  = "internal-route-${var.random_string}"
  }
}
