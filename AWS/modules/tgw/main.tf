
provider "aws" {
  region = var.aws_region
}

resource "aws_ec2_transit_gateway" "tgw" {
  description = "${var.customer_prefix}-${var.environment}-tgw for east-west inspection"
  tags = {
    Name        = "${var.customer_prefix}-${var.environment}-tgw"
    Environment = var.environment
  }
  amazon_side_asn                 = var.bgp_asn
  auto_accept_shared_attachments  = var.auto_accept_shared_attachments
  default_route_table_association = var.default_route_table_association
  default_route_table_propagation = var.default_route_table_propagation
  dns_support                     = var.dns_support
  vpn_ecmp_support                = var.vpn_ecmp_support
}
