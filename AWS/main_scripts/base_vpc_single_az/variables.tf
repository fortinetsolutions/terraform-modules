
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

variable "vpc_cidr" {
    description = "CIDR for the whole VPC"
}

variable "vpc_name" {
    description = "Name for VPC"
}

variable "public_subnet_cidr" {
    description = "CIDR for the Public Subnet"
}

variable "public_description" {
    description = "Description Public Subnet TAG"
}

variable "private_subnet_cidr" {
    description = "CIDR for the Private Subnet"
}

variable "private_description" {
    description = "Description Private Subnet TAG"
}


