
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
  description = "Availability Zone for VPC"
}

variable "use_fortigate_byol" {
  description = "Boolean Use the Fortigate BYOL AMI"
  type = bool
}

variable "cidr_block" {
    description = "CIDR for the whole VPC"
}

variable "subnet_bits" {
    description = "subnet bits used by each subnet within vpc_cidr range"
}
variable "subnet_count" {
    description = "subnets within the VPC e.g. public/private = 2"
}
variable "fortigate_host_ip" {
    description = "Host IP used by each Fortigate in the subnet"
}

variable "keypair" {
  description = "Keypair for instances that support keypairs"
}
variable "cidr_for_access" {
  description = "CIDR to use for security group access"
  default = "0.0.0.0/0"
}
variable "fortigate_instance_type" {
  description = "Instance type for fortigates"
}
variable "fortigate_instance_name" {
  description = "Instance Name for fortigate"
}
variable "acl" {
  description = "The S3 acl"
  default     = "private"
}
variable "fgt_byol_license" {
  description = "Fortigate license file"
}
variable "fortios_version" {
  description = "FortiOS Version for the AMI Search String"
}
variable "fgt_admin_password" {
  description = "Fortigate Admin Password"
}