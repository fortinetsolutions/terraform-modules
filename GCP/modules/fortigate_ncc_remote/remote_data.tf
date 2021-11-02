# Configuration for BYOL Instance using user-data
data "template_file" "setup-remote-instance" {
  template = file("${path.module}/remote")
  vars = {
    fgt_password              = var.password
    hostname                  = var.hostname
    public_gateway            = var.public_subnet_gateway
    clusterip                 = "cluster-ip-${var.random_string}"
    internalroute             = "internal-route-${var.random_string}"
    asn_remote                = var.asn_remote
    cr_bgppeers_peerasn_spoke = var.cr_bgppeers_peerasn_spoke
    router_ip_remote          = var.router_ip_remote
    router_ip_spoke           = var.router_ip_spoke
    subnet_cidr_remote        = var.subnet_cidr_remote
    spoke_site_ip             = var.spoke_site_ip
    remote_internal_ip_nic0   = var.remote_internal_ip_nic0
    remote_internal_ip_nic1   = var.remote_internal_ip_nic1
    subnet_cidr_ncc           = var.subnet_cidr_ncc
    subnet_cidr_spoke         = var.subnet_cidr_spoke
  }
}
