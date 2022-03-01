variable "aws_region" {
  description = "The AWS region to use"
  default = "us-east-1"
}
variable "fortigate_customer_prefix" {
  description = "Customer Prefix to apply to all resources"
}
variable "swan_customer_prefix" {
  description = "Customer Prefix to apply to all resources"
}
variable "environment" {
  description = "The Tag Environment to differentiate prod/test/dev"
}

#
# Standalone Variables that need to be provided
#

variable "cidr_for_access" {
  description = "CIDR Block Allowed"
}
variable "fortigate_availability_zone" {
  description = "Availability Zone for Fortigate Instance"
}
variable "swan_availability_zone" {
  description = "Availability Zone for SWAN Instance"
}
variable "fortigate_sg_name" {
  description = "Fortigate Security Group Name"
}
variable "fgt_admin_password" {
  description = "Fortigate Admin Password"
}
variable "fortigate_hostname" {
  description = "Fortigate Hostname 1"
}
variable "fortios_version" {
  description = "FortiOS Version for the AMI Search String"
}
variable "use_fortigate_byol" {
  description = "Boolean Use the Fortigate BYOL AMI"
  type = bool
}
variable "keypair" {
  description = "Keypair for instances that support keypairs"
}
variable "fortigate_instance_type" {
  description = "Instance type for fortigates"
}
variable "fortigate_instance_name" {
  description = "Instance Name for fortigate"
}
variable "acl" {
  description = "The S3 acl"
}
variable "fgt_byol_license" {
  description = "Fortigate license file"
}

#
#
#
variable "vpc_fortigate_cidr" {
  description = "VPC CIDR"
}
variable "vpc_fortigate_name" {
  description = "VPC Name"
}
variable "fortigate_public_ip_address" {
  description = "IP Address for Public 1 Subnet Fortigate ENI"
}
variable "fortigate_public_description" {
  description = "Description of public subnet"
}
variable "fortigate_private_description" {
  description = "Description of private subnet"
}
variable "fortigate_private_ip_address" {
  description = "IP Address for Private 1 Subnet Fortigate ENI"
}
variable "fortigate_public_subnet_cidr" {
    description = "CIDR for the Public 1 Subnet"
}
variable "fortigate_private_subnet_cidr" {
    description = "CIDR for the Private 1 Subnet"
}


#
#
#
variable "vpc_swan_cidr" {
  description = "VPC CIDR"
}
variable "vpc_swan_name" {
  description = "VPC Name"
}
variable "swan_public_ip_address" {
  description = "IP Address for Public 1 Subnet swan ENI"
}
variable "swan_public_description" {
  description = "Description of public subnet"
}
variable "swan_private_description" {
  description = "Description of private subnet"
}
variable "swan_private_ip_address" {
  description = "IP Address for Private 1 Subnet swan ENI"
}
variable "swan_public_subnet_cidr" {
    description = "CIDR for the Public 1 Subnet"
}
variable "swan_private_subnet_cidr" {
    description = "CIDR for the Private 1 Subnet"
}
variable "swan_sg_name" {
    description = "Security Group Name for SWAN EC2"
}
variable "swan_instance_type" {
  description = "Instance type for swan instance"
}
variable "swan_instance_name" {
  description = "Instance Name for swan instance"
}

#
# VPN configuration
#
variable swan_vpn_psk {}
variable fortigate_vpn_tunnel_name {}
