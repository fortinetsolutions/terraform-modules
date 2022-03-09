
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
variable "availability_zone_1" {
  description = "Availability Zone 1 for VPC"
}

variable "vpc_cidr" {
    description = "CIDR for the whole VPC"
}

variable "public_subnet_cidr" {
    description = "CIDR for the Public Subnet"
}

variable "use_fortigate_byol" {
  description = "Boolean Use the Fortigate BYOL AMI"
  type = bool
}

variable "fortios_version" {
  description = "FortiOS Version for the AMI Search String"
}
variable "public_ip_address" {
  description = "IP Address for Public Subnet Fortigate ENI"
}

variable "public_description" {
    description = "Description Public Subnet TAG"
}

variable "private_subnet_cidr" {
    description = "CIDR for the Private Subnet"
}

variable "private_ip_address" {
  description = "IP Address for Private Subnet Fortigate ENI"
}

variable "private_description" {
    description = "Description Private Subnet TAG"
}

variable "keypair" {
  description = "Keypair for instances that support keypairs"
}
variable "cidr_for_access" {
  description = "CIDR to use for security group access"
}
variable "fortigate_instance_type" {
  description = "Instance type for fortigates"
}
variable "fortigate_instance_name" {
  description = "Instance Name for fortigate"
}
variable "s3_license_bucket" {
  description = "S3 Bucket that contains BYOL License Files"
}
variable "acl" {
  description = "The S3 acl"
}
variable "fgt_byol_license" {
  description = "Fortigate license file"
}
variable "fortigate_sg_name" {
  description = "Fortigate Security Group Name"
}

variable "fortigate_hostname" {
  description = "Fortigate Hostname"
}

variable "fgt_admin_password" {
  description = "Fortigate Admin Password"
}