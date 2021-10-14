
variable "aws_region" {
  description = "The AWS region to use"
  default = "us-west-2"
}
variable "environment" {
  description = "The Tag Environment in the S3 tag"
  default = "stage"
}
variable "customer_prefix" {
  description = "Customer Prefix to apply to all resources"
}
variable "aws_ami" {
  description = "The AMI ID for the On-Demand image"
}
variable "keypair" {
  description = "Key Pair to use for the instance"
}
variable "instance_type" {
  description = "Instance Type"
}
variable "availability_zone" {
  description = "Availability Zone for this Instance"
}
variable "enable_private_interface" {
  description = "Boolean to Enable an Creation of HA Private ENI"
  default = false
}
variable "enable_sync_interface" {
  description = "Boolean to Enable an Creation of Sync ENI"
  default = false
}
variable "enable_hamgmt_interface" {
  description = "Boolean to Enable an Creation of HA Mgmt ENI"
  default = false
}
variable "api_termination_protection" {
  description = "If true, enables EC2 Instance Termination Protection"
  default     = false
}
variable "instance_name" {
  description = "Instance name"
}
variable "public_subnet_id" {
  description = "Public Subnet ID"
  default = ""
}
variable "public_ip_address" {
  description = "Public ENI IP address"
  default = ""
}
variable "private_subnet_id" {
  description = "Private Subnet ID"
  default = ""
}
variable "private_ip_address" {
  description = "Private ENI IP address"
  default = ""
}
variable "sync_subnet_id" {
  description = "Sync Subnet ID"
  default = ""
}
variable "sync_ip_address" {
  description = "Sync ENI IP address"
  default = ""
}
variable "ha_subnet_id" {
  description = "HA Subnet ID"
  default = ""
}
variable "ha_ip_address" {
  description = "HA ENI IP address"
  default = ""
}
variable "enable_public_ips" {
  description = "Boolean to Enable an Elastic IP on Public Interface"
}
variable "enable_mgmt_public_ips" {
  description = "Boolean to Enable an Elastic IP Mgmt Interface"
  default = false
}
variable "security_group_public_id" {
  description = "Security Group used by  ENI"
}
variable "security_group_private_id" {
  description = "Security Group used by Private ENI"
  default = ""
}
variable "acl" {
  description = "The S3 acl"
  default = "private"
}
variable "iam_instance_profile_id" {
  description = "IAM Instance Profile ID"
}
variable "userdata_rendered" {
  description = "rendered userdata for configuration"
}
