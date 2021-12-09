# Configuration for FGT Instance using data
data "template_file" "setup-fgt-instance" {
  template = file("${path.module}/fgt-template")
  vars = {
    admin_port               = var.admin_port
    fgt_password             = var.password
    private_vpc_cidr         = var.private_vpc_cidr
    private_vpc_gateway      = var.private_vpc_gateway
    mapped_ip                = var.mapped_ip
    external_loadbalancer_ip = google_compute_forwarding_rule.external_load_balancer.ip_address
    ilb_vip                  = var.ilb_vip
    gcp_lb1                  = var.gcp_lb1
    gcp_lb2                  = var.gcp_lb2
  }
}
