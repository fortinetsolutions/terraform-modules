provider "aws" {
  region     = var.aws_region
}

resource "aws_route_table" "route_table" {
  vpc_id            = var.vpc_id
  tags = {
        Name        = "${var.customer_prefix}-${var.environment}-${var.route_description}"
        Environment = var.environment
  }

}

resource "aws_route" "gateway" {
  count                  = var.gateway_route
  route_table_id         = aws_route_table.route_table.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = var.igw_id
}

resource "aws_route" "eni" {
  count                  = var.eni_route
  route_table_id         = aws_route_table.route_table.id
  destination_cidr_block = "0.0.0.0/0"
  network_interface_id   = var.eni_id
}

resource "aws_route" "tgw" {
  count                  = var.tgw_route
  route_table_id         = aws_route_table.route_table.id
  destination_cidr_block = "0.0.0.0/0"
  transit_gateway_id    = var.tgw_id
}
