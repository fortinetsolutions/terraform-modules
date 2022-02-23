
variable "aws_region" {
  description = "The AWS region to use"
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

variable "vpc_name_east" {
    description = "Name of east VPC"
}

variable "vpc_cidr_east" {
    description = "CIDR for the whole dev VPC"
}

variable "vpc_cidr_east-1" {
    description = "CIDR for east 1 subnet"
}


variable "vpc_cidr_east-2" {
    description = "CIDR for east 2 subnet"
}

variable "vpc_cidr_east-3" {
    description = "CIDR for east 3 subnet"
}

variable "keypair" {
  description = "Keypair for instances that support keypairs"
}
variable "acl" {
  description = "The S3 acl"
}
variable "cidr_for_access" {
  description = "CIDR to use for security group access"
}

#
# Ubuntu Endpoint resources
#
variable "ec2_sg_name" {
  description = "Linux Endpoint Security Group Name"
}
variable "linux_instance_type" {
  description = "Linux Endpoint Instance Type"
}
variable "enable_linux_instances" {
  description = "Boolean to allow creation of Linux Instances in East/West VPCs"
  type        = bool
}
variable "linux_instance_name_east" {
  description = "Linux Endpoint Instance Name"
}
