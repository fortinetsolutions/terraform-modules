output "vpc_id" {
  value       = module.base-vpc.vpc_id
  description = "The VPC Id of the newly created VPC."
}

output "public_subnet_id" {
  value = module.base-vpc.public_subnet_id
}

output "private_subnet_id" {
  value = module.base-vpc.private_subnet_id
}
