output "vpc_id" {
  value = aws_vpc.vpc.id
}

output "public_subnet1_id" {
  value = aws_subnet.public_subnet1.id
}

output "public_subnet2_id" {
  value = aws_subnet.public_subnet2.id
}

output "private_subnet1_id" {
  value = aws_subnet.private_subnet1.id
}

output "private_subnet2_id" {
  value = aws_subnet.private_subnet2.id
}

output "gwlb_subnet1_id" {
  value = aws_subnet.gwlb_subnet1.id
}

output "gwlb_subnet2_id" {
  value = aws_subnet.gwlb_subnet2.id
}

output "tgwattach_subnet1_id" {
  value = aws_subnet.tgwattach_subnet1.id
}

output "tgwattach_subnet2_id" {
  value = aws_subnet.tgwattach_subnet2.id
}