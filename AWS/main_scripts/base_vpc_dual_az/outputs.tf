output "vpc_id" {
  value       = module.vpc.vpc_id
  description = "The VPC Id of the newly created VPC."
}

output "public1_subnet_id" {
  value = module.public1-subnet.id
  description = "The Subnet Id of the newly created Public Subnet"
}

output "private1_subnet_id" {
  value = module.private1-subnet.id
    description = "The Subnet Id of the newly created Private Subnet"
}


output "public2_subnet_id" {
  value = module.public2-subnet.id
  description = "The Subnet Id of the newly created Public Subnet"
}

output "private2_subnet_id" {
  value = module.private2-subnet.id
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


output "private1_route_table_id" {
  value = module.private1_route_table.id
  description = "Id of the VPC Private 1 Route Table"
}


output "private2_route_table_id" {
  value = module.private2_route_table.id
  description = "Id of the VPC Private 2 Route Table"
}
