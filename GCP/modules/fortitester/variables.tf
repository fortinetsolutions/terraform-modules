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

variable "image" {
  type        = string
  description = "FortiTester Image"
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

variable "mgmt_vpc_network" {
  type        = string
  default     = "mgmt_vpc_network"
  description = "Managment VPC Network"
}

variable "mgmt_subnet" {
  default     = "mgmt_subnet"
  description = "Managment Subnet"
}

variable "port1_vpc_network" {
  type        = string
  default     = "port1_vpc_network"
  description = "Port1 VPC Network"
}

variable "port1_subnet" {
  default     = "port1_subnet"
  description = "Port1 Subnet"
}

variable "port2_vpc_network" {
  type        = string
  default     = "port2_vpc_network"
  description = "Managment VPC Network"
}

variable "port2_subnet" {
  default     = "port2_subnet"
  description = "Port2 Subnet"
}

variable "static_ip" {
  default     = "static_ip"
  description = "Static IP Address"
}
