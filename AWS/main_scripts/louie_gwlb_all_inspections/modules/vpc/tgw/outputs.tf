output "tgw_id" {
  value = aws_ec2_transit_gateway.transit_gateway.id
}

output "tgw_spoke_route_table_id" {
  value = aws_ec2_transit_gateway_route_table.transit_gateway_spoke_route_table.id
}

output "tgw_security_route_table_id" {
  value = aws_ec2_transit_gateway_route_table.transit_gateway_security_route_table.id
}