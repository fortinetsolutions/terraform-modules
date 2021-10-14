
variable "aws_region" {
    description = "Region for the DG VPC"
}

variable "customer_prefix" {
  description = "Customer Prefix to apply to all resources"
}

variable "environment" {
  description = "The Tag Environment in the S3 tag"
}

variable "vpc_name" {
  description = "VPC Name that uses this attachment. This is used for tagging only"
}

variable "transit_gateway_id" {
  description = "Transit Gateway ID used for this attachment"
}

variable "subnet_ids" {
  description = "Subnet IDs of subnets used to route traffic from the TGW into the VPC"
}

variable "dns_support" {
  description = "Whether DNS support is enable"
  default = "enable"
}

variable "vpc_id" {
  description = "VPC ID of the VPC that is connecting to the TGW"
}

variable transit_gateway_default_route_table_association {
  description = "Boolean whether the VPC Attachment should be associated with the EC2 Transit Gateway association default route table"
  default = "false"
}

variable transit_gateway_default_route_table_propogation {
  description = "Boolean whether the VPC Attachment should propagate routes with the EC2 Transit Gateway propagation default route table"
  default = "false"
}