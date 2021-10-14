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

### User Data Variables ###
variable "public_subnet_gateway" {
  type        = string
  description = "Port1 Gateway"
}

# Internal IP
variable "nginx_internal_ip" {
  default     = "nginx_internal_ip"
  description = "Nginx Internal IP Address"
}

# External IP
variable "static_ip" {
  default     = "static_ip"
  description = "Static IP Address"
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


