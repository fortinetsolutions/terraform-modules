# ---------------------------------------------------------------------------------------------------------------------
# REQUIRED PARAMETERS
# These parameters must be supplied when consuming this module.
# ---------------------------------------------------------------------------------------------------------------------
variable "service_account" {
  type        = string
  description = "Service Account"
}

variable "zone" {
  type        = string
  description = "Zone"
}

variable "machine" {
  type        = string
  description = "Machine Type"
}

variable "password" {
  type        = string
  default     = "fortinet"
  description = "FGT Password"
}

variable "image" {
  type        = string
  description = "FortiGate Image"
}

variable "public_subnet_gateway" {
  type        = string
  description = "Active Instance Port1 Gateway"
}

variable "cr_interface1_private_ip_spoke" {
  type        = string
  description = "Cloud Router Interface Private IP"
}

variable "cr_interface2_private_ip_spoke" {
  type        = string
  description = "Cloud Router Interface Private IP"
}

variable "cr_bgp_asn_spoke" {
  type        = string
  description = "Cloud Router BGP ASN"
}

variable "cr_bgppeers_peerasn_spoke" {
  type        = string
  description = "Cloud Router BGP-Peers ASN"
}

variable "router_ip_spoke" {
  type        = string
  description = "Router IP from the Spoke"
}

variable "router_ip_remote" {
  type        = string
  description = "Router IP from the Remote-Site "
}

variable "router_id_remote" {
  type        = string
  description = "Router ID from the Remote-Site "
}

variable "asn_remote" {
  type        = string
  description = "ASN from the Remote-Site"
}

variable "subnet_cidr_spoke" {
  type        = string
  description = "CIDR from Subnet - Spoke"
}

variable "remote_site_ip" {
  type        = string
  description = "IP Address of the Remote Site"
}

variable "remote_internal_ip_nic0" {
  type        = string
  description = "Internal IP Address - nic0 of the Remote"
}

variable "remote_internal_ip_nic1" {
  type        = string
  description = "Internal IP Address - nic1 of the Remote"
}

variable "subnet_cidr_ncc" {
  type        = string
  description = "Spoke Subnet0 CIDR"
}

variable "ncc_cloud_function" {
  type        = string
  description = "Cloud Function URL"
}

# ---------------------------------------------------------------------------------------------------------------------
# OPTIONAL PARAMETERS
# Generally, these values won't need to be changed.
# ---------------------------------------------------------------------------------------------------------------------
variable "name" {
  type        = string
  default     = "terraform"
  description = "Name"
}

variable "random_string" {
  type        = string
  default     = "abc"
  description = "Random String"
}

variable "license_file" {
  type        = string
  default     = ""
  description = "License File"
}

variable "public_vpc_network" {
  type        = string
  default     = "public_vpc_network_1"
  description = "Public VPC Network"
}

variable "private_vpc_network" {
  default     = "private_vpc_network_1"
  description = "Private VPC Network"
}

variable "public_subnet" {
  default     = "public_subnet"
  description = "Public Subnet"
}

variable "private_subnet" {
  default     = "private_subnet"
  description = "Private Subnet"
}

variable "static_ip" {
  default     = "static_ip"
  description = "Static IP Address"
}

variable "function_name" {
  type        = string
  default     = ""
  description = "Function Name"
}

variable "hostname" {
  type        = string
  default     = "hostname"
  description = "Host Name"
}