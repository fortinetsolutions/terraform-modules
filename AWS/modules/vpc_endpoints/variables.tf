
variable "aws_region" {
  description = "Provide the region to use"
}

variable "environment" {
  description = "The Tag Environment in the S3 tag"
  default = "stage"
}

variable "customer_prefix" {
  description = "Customer Prefix to apply to all resources"
}

variable "vpc_id" {
  description = "Provide the VPC ID for the instance"
}
variable "route_table_id" {
  description = "Route Table IDS for Gateway Endpoint"
}