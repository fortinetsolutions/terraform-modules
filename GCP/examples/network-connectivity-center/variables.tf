variable "credentials_file_path" {}
variable "service_account" {}
variable "project" {}
variable "name" {}
variable "spoke1_region" {}
variable "spoke2_region" {}
variable "spoke1_zone" {}
variable "spoke2_zone" {}
variable "machine" {}
variable "image" {}
variable "license_file_1" {}
variable "license_file_2" {}
variable "license_file_3" {}
variable "license_file_4" {}
variable "password" {
  type        = string
  default     = "fortinet"
  description = "FGT Password"
}
# vpc Module
variable "spoke_vpcs" {}
variable "remote1_vpcs" {}
variable "remote2_vpcs" {}
# variable "spoke1_vpcs" {}
# variable "spoke2_vpcs" {}
variable "vpc_routing_mode" {}
# subnet Module
variable "ncc_subnets" {}
variable "ncc_subnet_cidrs" {}
variable "spoke1_subnets" {}
variable "spoke1_subnet_cidrs" {}
variable "spoke2_subnets" {}
variable "spoke2_subnet_cidrs" {}
variable "remote1_subnets" {}
variable "remote1_subnet_cidrs" {}
variable "remote2_subnets" {}
variable "remote2_subnet_cidrs" {}
# Firewall Module
variable "fw_ingress" {}
variable "fw_egress" {}
# NCC
variable "hub_name" {}
# Spoke-1
variable "hostname_spoke1" {}
variable "cr_bgp_asn_spoke1" {}
variable "cr_bgppeers_peerasn_spoke1" {}
variable "cr_interface1_private_ip_spoke1" {}
variable "cr_interface2_private_ip_spoke1" {}
variable "router_ip_spoke1" {}
# Remote-Site-1
variable "hostname_remote1" {}
variable "router_id_remote1" {}
variable "router_ip_remote1" {}
variable "asn_remote1" {}
variable "internal_ip_nic0_remote1" {}
variable "internal_ip_nic1_remote1" {}
# Spoke-2
variable "hostname_spoke2" {}
variable "cr_bgp_asn_spoke2" {}
variable "cr_bgppeers_peerasn_spoke2" {}
variable "cr_interface1_private_ip_spoke2" {}
variable "cr_interface2_private_ip_spoke2" {}
variable "router_ip_spoke2" {}
# Remote-Site-2
variable "hostname_remote2" {}
variable "router_id_remote2" {}
variable "router_ip_remote2" {}
variable "asn_remote2" {}
variable "internal_ip_nic0_remote2" {}
variable "internal_ip_nic1_remote2" {}
