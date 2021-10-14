
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
variable "vpc_name_security" {
    description = "Name of Security VPC"
}
variable "availability_zone_1" {
  description = "Availability Zone 1 for VPC"
}

variable "availability_zone_2" {
  description = "Availability Zone 2 for VPC"
}
variable "vpc_cidr_security" {
    description = "CIDR for the whole security VPC"
}

variable "public_subnet_cidr1" {
    description = "CIDR for the Public 1 Subnet"
}

variable "public_subnet_cidr2" {
    description = "CIDR for the Public 2 Subnet"
}
variable "public1_description" {
    description = "Description Public 1 Subnet TAG"
}

variable "public2_description" {
    description = "Description Public 2 Subnet TAG"
}

variable "public1_ip_address" {
  description = "IP Address for Public 1 Subnet Fortiweb ENI"
}

variable "public2_ip_address" {
  description = "IP Address for Public 2 Subnet Fortiweb ENI"
}

variable "private_subnet_cidr_1" {
    description = "CIDR for the Private 1 Subnet"
}
variable "private1_description" {
    description = "Description Private 1 TO Subnet TAG"
}

variable "private_subnet_cidr_2" {
    description = "CIDR for the Private 2 TO Subnet"
}

variable "private2_description" {
    description = "Description Private Subnet TAG"
}

variable "private2_ip_address" {
  description = "IP Address for Private 2 Subnet Fortiweb ENI"
}

variable "private1_ip_address" {
  description = "IP Address for Private 1 Subnet Fortiweb ENI"
}

variable keypair {
  description = "Keypair used to login to FortiWeb"
}
variable fortiweb_instance_type {
  description = "EC2 Instance Type of FortiWeb"
}
variable fortiweb_1_instance_name {
  description = "Instance name of FortiWeb AZ1"
}
variable fortiweb_2_instance_name {
  description = "Instance name of FortiWeb AZ2"
}
variable fortiweb_sg_name {
  description = "FortiWeb Security Group Name"
}
variable "fortiweb_os_version" {
  description = "FortiWeb OS Version got AMI Search String"
}
variable "fwb_s3_bucket" {
  description = "FortiWeb S3 Bucket used for config files"
}
variable "fwb_byol_license_1" {
  description = "Fortiweb license file"
}
variable "fwb_byol_license_2" {
  description = "Fortiweb license file"
}
variable "acl" {
  description = "Fortiweb ACL"
}
variable "enable_public_ips_1" {
  description = "Boolean to associate a public EIP with the instance"
}
variable "enable_public_ips_2" {
  description = "Boolean to associate a public EIP with the instance"
}
variable "use_fortiweb_byol" {
  description = "Use BYOL version of FortiWeb"
}
variable "fwb_admin_password" {
  description = "FortiWeb Admin Password"
}