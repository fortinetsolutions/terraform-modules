output "gwlb_arn_suffix" {
  value = aws_lb.gwlb.*.arn_suffix
}

output "gwlb_ip1" {
  value = flatten(data.aws_network_interface.gwlb_ip1.*.private_ips)
}

output "gwlb_ip2" {
  value = flatten(data.aws_network_interface.gwlb_ip2.*.private_ips)
}

output "gwlb_endpoint_service_name" {
  value = aws_vpc_endpoint_service.gwlb_endpoint_service.service_name
}

output "gwlb_endpoint_service_type" {
  value = aws_vpc_endpoint_service.gwlb_endpoint_service.service_type
}