
variable "aws_region" {
  description = "The AWS region to use"
  default = "us-east-1"
}
variable "customer_prefix" {
  description = "Customer Prefix to apply to all resources"
}
variable "environment" {
  description = "The Tag Environment to differentiate prod/test/dev"
}
variable "availability_zone" {
  description = "Availability Zone 1 for VPC"
}
variable vpc_id {
  description = "VPC ID to deploy Fortimanager"
}
variable subnet_id {
  description = "Subnet ID to deploy Fortimanager"
}
variable ip_address {
  description = "IP Address for Public Interface of Fortimanager"
}
variable keypair {
  description = "Keypair used to login to Fortimanager"
}
variable fortimanager_instance_type {
  description = "EC2 Instance Type of Fortimanager"
}
variable fortimanager_instance_name {
  description = "Instance name of Fortimanager"
}
variable fortimanager_sg_name {
  description = "Fortimanager Security Group Name"
}
variable "fortimanager_os_version" {
  description = "FortiManager OS Version got AMI Search String"
}
variable "fmgr_byol_license" {
  description = "Fortigate license file"
}
variable "acl" {
  description = "Fortimanager ACL"
}
variable "enable_public_ips" {
  description = "Boolean to associate a public EIP with the instance"
}
variable "use_fortimanager_byol" {
  description = "Use BYOL version of FortiManager"
}
variable "fmgr_admin_password" {
  description = "Fortimanager Admin Password"
}