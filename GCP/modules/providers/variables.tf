variable "project" {
  default     = "<GCP_Project>"
  description = "GCP Project Name"
}

variable "project_credentials" {
  default     = "<project_credentials>"
  description = "GCP Project Credentials"
}

variable "region" {
  default     = "us-central1"
  description = "Region"
}

variable "zone" {
  default     = "us-central1-c"
  description = "Zone"
}
