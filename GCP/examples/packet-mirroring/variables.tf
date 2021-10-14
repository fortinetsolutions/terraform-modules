variable "credentials_file_path" {}
variable "service_account" {}
variable "project" {}
variable "name" {}
variable "region" {}
variable "zone" {}
variable "fgt_machine" {}
variable "tag" {}
variable "image" {}
variable "ubuntu_image" {}
variable "ubuntu_machine" {}
variable "instance_count" {}
variable "admin_port" {}
# VPC Module
variable "vpcs" {}
# Subnet Module
variable "subnets" {}
variable "subnet_cidrs" {}
# Instance Template variables
variable "password" {
  type        = string
  default     = "fortinet"
  description = "FGT Password"
}
variable "int_check_interval_sec" {}
variable "int_timeout_sec" {}
variable "int_port" {}
