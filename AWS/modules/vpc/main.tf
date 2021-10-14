provider "aws" {
  region     = var.aws_region
}

resource "aws_vpc" "vpc" {
  cidr_block            = var.vpc_cidr
  enable_dns_hostnames  = true
  tags = {
    Name                = "${var.customer_prefix}-${var.environment}-${var.vpc_name}-vpc"
    Environment         = var.environment
  }
}

