variable "credentials_file_path" {}
variable "service_account" {}
variable "project" {}
variable "name" {}
variable "region" {}
variable "zone" {}
# vpc module
variable "vpcs" {}
variable "vpc_routing_mode" {}
# subnet module
variable "subnets" {}
variable "subnet_cidrs" {}
# VPN
variable "shared_secret" {}
# Cloud Router
variable "cr_asn" {}
variable "cr_interface_ip_range" {}
variable "cr_peer_ip_address" {}
variable "cr_peer_asn" {}
variable "cr_advertised_route_priority" {}
# FGT in Other Cloud
variable fgt_ip {}
