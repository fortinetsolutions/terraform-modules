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
  default     = "ftntCl0ud"
  description = "FMG Password"
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

variable "public_subnet" {
  default     = "public_subnet"
  description = "Public Subnet"
}

variable "static_ip" {
  default     = "static_ip"
  description = "Static IP Address"
}
