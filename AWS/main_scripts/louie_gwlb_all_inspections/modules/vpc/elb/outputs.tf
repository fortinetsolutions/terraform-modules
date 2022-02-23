output "alb_dns" {
  value = aws_lb.alb.*.dns_name
  depends_on = [aws_lb.alb]
}

output "nlb_dns" {
  value = aws_lb.nlb.*.dns_name
  depends_on = [aws_lb.nlb]
}

output "gwlb_arn_suffix" {
  value = aws_lb.gwlb.*.arn_suffix
  depends_on = [aws_lb.gwlb]
}

output "gwlb_enis" {
  value = "flatten(data.aws_network_interfaces.gwlb_enis.*.ids)"
  depends_on = [aws_lb.gwlb]
}