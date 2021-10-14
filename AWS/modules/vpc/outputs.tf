output "vpc_id" {
  value       = aws_vpc.vpc.id
  description = "The VPC Id of the newly created VPC."
}
output "vpc_main_route_table_id" {
  value       = aws_vpc.vpc.main_route_table_id
  description = "Main Route Table Associated with VPC"
}
