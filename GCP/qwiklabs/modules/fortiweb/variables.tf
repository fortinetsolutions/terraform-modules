# ---------------------------------------------------------------------------------------------------------------------
# REQUIRED PARAMETERS
# These parameters must be supplied when consuming this module.
# ---------------------------------------------------------------------------------------------------------------------
variable "zone" {
  type        = string
  description = "Zone"
}

variable "machine" {
  type        = string
  description = "Machine Type"
}

variable "image" {
  type        = string
  description = "FWEB Image"
}

variable "license_file" {
  type        = string
  description = "License File"
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
  default     = "public_vpc_network"
  description = "Public VPC Network"
}

variable "private_vpc_network" {
  default     = "private_vpc_network"
  description = "Private VPC Network"
}

variable "mgmt_vpc_network" {
  default     = "mgmt_vpc_network"
  description = "Management VPC Network"
}

variable "public_subnet" {
  default     = "public_subnet"
  description = "Public Subnet"
}

variable "private_subnet" {
  default     = "private_subnet"
  description = "Private Subnet"
}

variable "mgmt_subnet" {
  default     = "mgmt_subnet"
  description = "Management Subnet"
}

variable "static_ip" {
  default     = "static_ip"
  description = "Static IP Address"
}
