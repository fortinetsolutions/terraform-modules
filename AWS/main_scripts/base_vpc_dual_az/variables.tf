
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

variable "vpc_name" {
  description = "VPC Name"
}

variable "availability_zone1" {
  description = "Availability Zone 1 for VPC"
}

variable "availability_zone2" {
  description = "Availability Zone 2 for VPC"
}

variable "vpc_cidr" {
    description = "CIDR for the whole VPC"
}

variable "public1_subnet_cidr" {
    description = "CIDR for the Public Subnet 1"
}

variable "public1_description" {
    description = "Description Public Subnet 1 TAG"
}

variable "private1_subnet_cidr" {
    description = "CIDR for the Private Subnet 1"
}

variable "private1_description" {
    description = "Description Private Subnet 1 TAG"
}

variable "public2_subnet_cidr" {
    description = "CIDR for the Public Subnet 2"
}

variable "public2_description" {
    description = "Description Public Subnet 2 TAG"
}

variable "private2_subnet_cidr" {
    description = "CIDR for the Private Subnet 2"
}

variable "private2_description" {
    description = "Description Private Subnet 2 TAG"
}


