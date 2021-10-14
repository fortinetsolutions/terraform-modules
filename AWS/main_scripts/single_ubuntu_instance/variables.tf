
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

variable "public_subnet_cidr1" {
    description = "CIDR for the Public 1 Subnet"
}

variable "public1_ip_address" {
  description = "IP Address for Public 1 Subnet Fortigate ENI"
}

variable "public1_description" {
    description = "Description Public 1 Subnet TAG"
}

variable "private_subnet_cidr1" {
    description = "CIDR for the Private 1 Subnet"
}

variable "private1_ip_address" {
  description = "IP Address for Private 1 Subnet Fortigate ENI"
}

variable "private1_description" {
    description = "Description Private 1 Subnet TAG"
}

variable "keypair" {
  description = "Keypair for instances that support keypairs"
}

variable "cidr_for_access" {
  description = "CIDR to use for security group access"
}

variable "public_ip" {
  description = "Boolean to determine if endpoints should associate a public ip"
}

variable "acl" {
  description = "The S3 acl"
}

variable "ec2_sg_name" {
  description = "Linux Endpoint Security Group Name"
}

variable "linux_instance_type" {
  description = "Linux Endpoint Instance Type"
}

variable "linux_instance_name" {
  description = "Linux Endpoint Instance Name"
}


