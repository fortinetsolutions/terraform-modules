
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

variable "subnet_ids" {
  description = "Subnet IDs for Route Table Associations"
}

variable "route_table_id" {
  description = "Route Table ID to associate with"
}