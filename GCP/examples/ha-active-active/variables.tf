variable "credentials_file_path" {}
variable "service_account" {}
variable "project" {}
variable "name" {}
variable "region" {}
variable "zone" {}
variable "machine" {}
variable "image" {}
variable "bastionhost_image" {}
variable "bastionhost_machine" {}
variable "admin_port" {}
# Zones to use with Instance Group
data "google_compute_zones" "get_zones" {
}
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
variable "private_vpc_gateway" {}
variable "private_vpc_cidr" {}
variable "mapped_ip" {}
# Managed Instance Group
variable "target_size" {}
variable "autohealing_check_interval_sec" {}
variable "autohealing_timeout_sec" {}
variable "autohealing_healthy_threshold" {}
variable "autohealing_unhealthy_threshold" {}
variable "autohealing_tcp_health_check" {}
variable "initial_delay_sec" {}
# External Load Balancer
variable "elb_check_interval_sec" {}
variable "elb_timeout_sec" {}
variable "elb_unhealthy_threshold" {}
variable "elb_port" {}
# Internal Load Balancer
variable "int_check_interval_sec" {}
variable "int_timeout_sec" {}
variable "int_port" {}
variable "ilb_vip" {}
# Custom
variable "gcp_lb1" {}
variable "gcp_lb2" {}
