output "vpc_id" {
  value       = module.base-vpc.vpc_id
  description = "The VPC Id of the newly created VPC."
}

output "public1_subnet_id" {
  value       = module.base-vpc.public1_subnet_id
  description = "The Public Subnet ID for AZ 1"
}

output "private1_subnet_id" {
  value       = module.base-vpc.private1_subnet_id
  description = "The Private Subnet ID for AZ 1"
}

output "network_public_1_eni_id" {
  value       = module.fortigate_1.network_public_interface_id
  description = "The Fortigate ENI ID in the Public Subnet in AZ 1"
}

output "network_private_1_eni_id" {
  value       = module.fortigate_1.network_private_interface_id
  description = "The Fortigate ENI ID in the Private Subnet in AZ 1"
}
output "fortigate_1_instance_id" {
  value       = module.fortigate_1.instance_id
  description = "The Fortigate Instance ID for AZ 1"
}

output "public2_subnet_id" {
  value       = module.base-vpc.public2_subnet_id
  description = "The Fortigate ENI ID in the Public Subnet in AZ 2"
}

output "private2_subnet_id" {
  value         = module.base-vpc.private2_subnet_id
    description = "The Private Subnet ID for AZ 2"
}

output "network_public_2_eni_id" {
  value       = module.fortigate_2.network_public_interface_id
  description = "The Fortigate ENI ID in the Public Subnet in AZ 2"
}

output "network_private_2_eni_id" {
  value = module.fortigate_2.network_private_interface_id
  description = "The Fortigate ENI ID in the Private Subnet in AZ 2"
}
output "fortigate_2_instance_id" {
  value       = module.fortigate_2.instance_id
  description = "The Fortigate Instance ID for AZ 2"
}
//output "east_instance_id" {
//  value       = module.east_instance.instance_id
//  description = "The Linux Instance ID for East VPC"
//}
//output "west_instance_id" {
//  value       = module.west_instance.instance_id
//  description = "The Linux Instance ID for West VPC"
//}
