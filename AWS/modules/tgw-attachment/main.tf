
resource "aws_ec2_transit_gateway_vpc_attachment" "tgw-attach" {
  tags = {
    Name        = "${var.customer_prefix}-${var.environment}-${var.vpc_name}-tgw-attach"
    Environment = var.environment
  }
  transit_gateway_id                              = var.transit_gateway_id
  vpc_id                                          = var.vpc_id
  subnet_ids                                      = var.subnet_ids
  transit_gateway_default_route_table_association = var.transit_gateway_default_route_table_association
  transit_gateway_default_route_table_propagation = var.transit_gateway_default_route_table_propogation
  dns_support                                     = var.dns_support
}
