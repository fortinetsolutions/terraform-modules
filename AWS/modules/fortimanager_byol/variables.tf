
variable "aws_region" {
  description = "The AWS region to use"
}

variable "environment" {
  description = "The Tag Environment in the S3 tag"
}

variable "customer_prefix" {
  description = "Customer Prefix to apply to all resources"
}

variable "aws_fmgrbyol_ami" {
  description = "The AMI ID for the byol image"
}

variable "keypair" {
  description = "Key Pair to use for the instance"
}
variable "fmgr_instance_type" {
  description = "Fortimanager Instance Type"
}

variable "availability_zone" {
  description = "Availability Zone for this Fortimanager Instance"
}
variable "fortimanager_instance_name" {
  description = "Instance name of Fortimanager"
}
variable "subnet_id" {
  description = "Public Subnet ID"
}
variable "ip_address" {
  description = "Public ENI IP address"
}
variable "security_group_public_id" {
  description = "Security Group used by  ENI"
}
variable "fmgr_byol_license" {
  description = "Fortimanager BYOL License File"
}
