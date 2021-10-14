# ---------------------------------------------------------------------------------------------------------------------
# REQUIRED PARAMETERS
# These parameters must be supplied when consuming this module.
# ---------------------------------------------------------------------------------------------------------------------

variable "peerings" {
  type = list
}

variable "export_custom_routes" {
  type        = bool
  default     = false
  description = "Export Custom Routes"
}

variable "import_custom_routes" {
  type        = bool
  default     = false
  description = "Import Custom Routes"
}

# ---------------------------------------------------------------------------------------------------------------------
# OPTIONAL PARAMETERS
# Generally, these values won't need to be changed.
# ---------------------------------------------------------------------------------------------------------------------
variable "name" {
  type        = string
  default     = "terraform-vpc-peering"
  description = "Name"
}

variable "random_string" {
  default     = "abc"
  description = "Random String"
}


