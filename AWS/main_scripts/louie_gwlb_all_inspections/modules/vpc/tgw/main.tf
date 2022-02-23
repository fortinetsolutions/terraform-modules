resource "aws_ec2_transit_gateway" "transit_gateway" {
  auto_accept_shared_attachments = "disable"
  default_route_table_association = "disable"
  default_route_table_propagation = "disable"
  vpn_ecmp_support = "enable"
  dns_support = "enable"
  amazon_side_asn = "64512"
  tags = {
    Name = "${var.tag_name_prefix}-tgw"
  }
}

resource "aws_ec2_transit_gateway_route_table" "transit_gateway_security_route_table" {
  transit_gateway_id = aws_ec2_transit_gateway.transit_gateway.id
  tags = {
    Name = "${var.tag_name_prefix}-security-tgw-rt"
  }
}

resource "aws_ec2_transit_gateway_route_table" "transit_gateway_spoke_route_table" {
  transit_gateway_id = aws_ec2_transit_gateway.transit_gateway.id
  tags = {
    Name = "${var.tag_name_prefix}-spoke-tgw-rt"
  }
}