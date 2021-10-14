output "vpc_id" {
  value       = module.vpc.vpc_id
  description = "The VPC Id of the newly created VPC."
}

output "public_subnet_id" {
  value = module.public-subnet.id
  description = "The Subnet Id of the newly created Public Subnet"
}

output "private_subnet_id" {
  value = module.private-subnet.id
    description = "The Subnet Id of the newly created Private Subnet"
}

output "vpc_main_route_table_id" {
  value = module.vpc.vpc_main_route_table_id
  description = "Id of the VPC default route table"
}

output "public_route_table_id" {
  value = module.public_route_table.id
  description = "Id of the VPC Public Route Table"
}

output "private_route_table_id" {
  value = module.private_route_table.id
  description = "Id of the VPC Private Route Table"
}

