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

variable "password" {
  type        = string
  default     = "ftntCl0ud"
  description = "FGT Password"
}

variable "image" {
  type        = string
  description = "Ubuntu Image"
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
