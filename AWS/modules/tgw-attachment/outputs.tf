
output "tgw_attachment_id" {
  value = aws_ec2_transit_gateway_vpc_attachment.tgw-attach.id
  description = "The Transit Gateway Id for the newly created TGW"
}
