
variable "aws_region" {
  description = "The AWS region to use"
}

variable "customer_prefix" {
  description = "Customer Prefix to apply to all resources"
}

variable "environment" {
  description = "The Tag Environment in the S3 tag"
  default = "stage"
}

variable "vpc_id" {
  description = "Route Table VPC ID"
}

variable "eni_route" {
  description = "Boolean to Create an ENI Route"
  default     = 0
}

variable "gateway_route" {
  description = "Boolean to Create an Gateway Route"
  default     = 0
}

variable "tgw_route" {
  description = "Boolean to Create a Transit Gateway Route"
  default     = 0
}

variable "eni_id" {
  description = "Network Interface to use for ENI Route"
  default     = null
}

variable "igw_id" {
  description = "Internet Gateway ID to use for the Gateway Route"
  default     = null
}

variable "tgw_id" {
  description = "Transit Gateway to use for the TGW Route"
  default     = null
}

variable "route_description" {
  description = "Route Description for Tag"
}