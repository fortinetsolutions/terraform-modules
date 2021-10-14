# ---------------------------------------------------------------------------------------------------------------------
# REQUIRED PARAMETERS
# These parameters must be supplied when consuming this module.
# ---------------------------------------------------------------------------------------------------------------------


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

variable "vpc_network" {
  type        = string
  default     = "vpc_network"
  description = "VPC Network"
}

variable "dest_range" {
  type        = string
  default     = "0.0.0.0/0"
  description = "Destination Range"
}

variable "priority" {
  type        = string
  default     = 100
  description = "Priority"
}

variable "route_depends_on" {
  type    = any
  default = null
}

variable "next_hop_ip" {
  type        = string
  description = "Next Hop IP"
  default     = null
}

variable "next_hop_gateway" {
  type        = string
  description = "Next Hop Gateway"
  default     = null
}

variable "tags" {
  type        = list(string)
  description = "Tags"
  default     = null
}
