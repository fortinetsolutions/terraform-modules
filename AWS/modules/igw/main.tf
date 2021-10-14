
provider "aws" {
  region = var.aws_region
}

resource "aws_internet_gateway" "igw" {
  vpc_id = var.vpc_id
  tags = {
    Name        = "${var.customer_prefix}-${var.environment}-igw"
    Environment = var.environment
  }
}
