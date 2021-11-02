# Configuration for NCC using user-data
data "template_file" "setup-ncc-instance" {
  template = file("${path.module}/ncc")
  vars = {
    fgt_password                   = var.password
    hostname                       = var.hostname
    public_gateway                 = var.public_subnet_gateway
    cr_interface1_private_ip_spoke = var.cr_interface1_private_ip_spoke
    cr_interface2_private_ip_spoke = var.cr_interface2_private_ip_spoke
    cr_bgp_asn_spoke               = var.cr_bgp_asn_spoke
    cr_bgppeers_peerasn_spoke      = var.cr_bgppeers_peerasn_spoke
    router_ip_spoke                = var.router_ip_spoke
    router_id_remote               = var.router_id_remote
    router_ip_remote               = var.router_ip_remote
    asn_remote                     = var.asn_remote
    subnet_cidr_ncc                = var.subnet_cidr_ncc
    subnet_cidr_spoke              = var.subnet_cidr_spoke
    remote_site_ip                 = var.remote_site_ip
    remote_internal_ip_nic0        = var.remote_internal_ip_nic0
    remote_internal_ip_nic1        = var.remote_internal_ip_nic1
    ncc_cloud_function             = var.ncc_cloud_function
    clusterip                      = "cluster-ip-${var.random_string}"
    internalroute                  = "internal-route-${var.random_string}"
  }
}

# data "template_cloudinit_config" "config" {
#   gzip          = false
#   base64_encode = false

#   # Main cloud-config configuration file.
#   part {
#     filename     = "init.cfg"
#     content_type = "text/cloud-config"
#     content      = "${data.template_file.setup-ncc-instance.rendered}"
#   }

#   part {
#     content_type = "text/cloud-config"
#     content      = "{'config-url':'${var.function_name}'}"
#   }
# }
