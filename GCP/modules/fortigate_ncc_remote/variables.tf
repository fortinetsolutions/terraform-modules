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

variable "license_file" {
  type        = string
  description = "License File"
}

variable "public_subnet_gateway" {
  type        = string
  description = "Active Instance Port1 Gateway"
}

variable "asn_remote" {
  type        = string
  description = "ASN from the Remote-Site"
}

variable "cr_bgppeers_peerasn_spoke" {
  type        = string
  description = "Cloud Router BGP-Peers ASN"
}

variable "router_ip_remote" {
  type        = string
  description = "Router IP from the Remote-Site "
}

variable "router_ip_spoke" {
  type        = string
  description = "Router IP from the Spoke"
}

variable "subnet_cidr_remote" {
  type        = string
  description = "CIDR from Subnet - Remote"
}

variable "spoke_site_ip" {
  type        = string
  description = "IP Address of the Spoke Site"
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
  description = "Spoke Subnet0 CIDR - NCC"
}

variable "subnet_cidr_spoke" {
  type        = string
  description = "Spoke Subnet1 CIDR - Spoke"
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