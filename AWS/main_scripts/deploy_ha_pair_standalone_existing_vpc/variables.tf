variable "access_key" {}
variable "secret_key" {}

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

#
# Standalone Variables that need to be provided
#
variable "vpc_id" {
  description = "VPC ID when deploying into an existing VPC"
}

variable "public_route_table_id" {
  description = "Route table ID of Public Route table when deploying into an existing VPC"
}

variable "public1_subnet_id" {
  description = "Subnet ID of the Public Subnet in AZ1 when deploying into an existing VPC"
}

variable "public2_subnet_id" {
  description = "Subnet ID of the Public Subnet in AZ2 when deploying into an existing VPC"
}

variable "private1_subnet_id" {
  description = "Subnet ID of the Private Subnet in AZ1 when deploying into an existing VPC"
}

variable "private2_subnet_id" {
  description = "Subnet ID of the Private Subnet in AZ1 when deploying into an existing VPC"
}

variable "availability_zone_1" {
  description = "Availability Zone 1 for VPC"
}

variable "availability_zone_2" {
  description = "Availability Zone 2 for VPC"
}
variable "fortigate_sg_name" {
  description = "Fortigate Security Group Name"
}
variable "vpc_name_security" {
    description = "Name of Security VPC"
}

variable "vpc_name_east" {
    description = "Name of east VPC"
}

variable "vpc_name_west" {
    description = "Name of west VPC"
}

variable "vpc_cidr_security" {
    description = "CIDR for the whole security VPC"
}

variable "vpc_cidr_east" {
    description = "CIDR for the whole dev VPC"
}

variable "vpc_cidr_west" {
    description = "CIDR for the whole test VPC"
}

variable "public_subnet_cidr1" {
    description = "CIDR for the Public 1 Subnet"
}

variable "public_subnet_cidr2" {
    description = "CIDR for the Public 2 Subnet"
}

variable "public1_ip_address" {
  description = "IP Address for Public 1 Subnet Fortigate ENI"
}

variable "public2_ip_address" {
  description = "IP Address for Public 2 Subnet Fortigate ENI"
}

variable "public1_description" {
    description = "Description Public 1 Subnet TAG"
}

variable "public2_description" {
    description = "Description Public 2 Subnet TAG"
}

variable "private_subnet_cidr_1" {
    description = "CIDR for the Private 1 Subnet"
}
variable "private1_description" {
    description = "Description Private 1 TO Subnet TAG"
}

variable "private1_subnet_tgw_cidr" {
    description = "CIDR for the Private 1 TGW Subnet"
}

variable "private1_tgw_description" {
    description = "Description Private 1 TGW Subnet TAG"
}


variable "private2_subnet_tgw_cidr" {
    description = "CIDR for the Private 2 TGW Subnet"
}

variable "private2_tgw_description" {
    description = "Description Private 2 TGW Subnet TAG"
}

variable "private_subnet_cidr_2" {
    description = "CIDR for the Private 2 TO Subnet"
}

variable "private2_description" {
    description = "Description Private Subnet TAG"
}

variable "private2_ip_address" {
  description = "IP Address for Private 2 Subnet Fortigate ENI"
}

variable "private1_ip_address" {
  description = "IP Address for Private 1 Subnet Fortigate ENI"
}

variable "sync_subnet_cidr_1" {
    description = "CIDR for the SYNC AZ 1 Subnet"
}

variable "sync_description_1" {
    description = "Description SYNC AZ 1 Subnet TAG"
}

variable "sync_subnet_ip_address_1" {
  description = "IP Address for SYNC AZ1 Subnet Fortigate ENI"
}

variable "sync_subnet_cidr_2" {
    description = "CIDR for the SYNC AZ 2 Subnet"
}

variable "sync_description_2" {
    description = "Description SYNC AZ 2 Subnet TAG"
}

variable "sync_subnet_ip_address_2" {
  description = "IP Address for SYNC AZ2 Subnet Fortigate ENI"
}

variable "ha_subnet_cidr_1" {
    description = "CIDR for the HA AZ 1 Subnet"
}

variable "ha_description_1" {
    description = "Description HA AZ 1 Subnet TAG"
}

variable "ha_subnet_ip_address_1" {
  description = "IP Address for HA AZ1 Subnet Fortigate ENI"
}

variable "ha_subnet_cidr_2" {
    description = "CIDR for the HA AZ 2 Subnet"
}

variable "ha_description_2" {
    description = "Description HA AZ 2 Subnet TAG"
}

variable "ha_subnet_ip_address_2" {
  description = "IP Address for HA AZ2 Subnet Fortigate ENI"
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
variable "fortigate_instance_name_1" {
  description = "Instance Name for fortigate"
}
variable "fortigate_instance_name_2" {
  description = "Instance Name for fortigate"
}
variable "use_fortigate_byol" {
  description = "Boolean Use the Fortigate BYOL AMI"
  type = bool
}
variable "acl" {
  description = "The S3 acl"
}
variable "fortios_version" {
  description = "FortiOS Version for the AMI Search String"
}
variable "fgt_byol_1_license" {
  description = "Fortigate license file"
}
variable "fgt_byol_2_license" {
  description = "Fortigate license file"
}
variable "fgt_ha_password" {
  description = "Fortigate HA Password"
}
variable "fgt_admin_password" {
  description = "Fortigate Admin Password"
}
variable "fortigate_hostname_1" {
  description = "Fortigate Hostname 1"
}
variable "fortigate_hostname_2" {
  description = "Fortigate Hostname 2"
}
