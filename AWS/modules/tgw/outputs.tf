
output "tgw_id" {
  value = aws_ec2_transit_gateway.tgw.id
  description = "The Transit Gateway Id for the newly created TGW"
}

output "tgw_arn" {
  value = aws_ec2_transit_gateway.tgw.arn
  description = "EC2 Transit Gateway Amazon Resource Name"
}
output "rtb_id" {
  value = aws_ec2_transit_gateway.tgw.propagation_default_route_table_id
  description = "Identifier of the default propagation route table"
}
