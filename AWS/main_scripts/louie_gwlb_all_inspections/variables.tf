
variable "region" {
  description = "Provide the region to deploy the VPC in"
  default = "us-east-1"
}
variable "availability_zone1" {
  description = "Provide the first availability zone to create the subnets in"
  default = "us-east-1a"
}
variable "availability_zone2" {
  description = "Provide the second availability zone to create the subnets in"
  default = "us-east-1b"
}
variable "security_vpc_cidr" {
  description = "Provide the network CIDR for the VPC"
  default = "10.0.0.0/16"
}
variable "security_vpc_public_subnet_cidr1" {
  description = "Provide the network CIDR for the public subnet1 in security vpc"
  default = "10.0.1.0/24"
}
variable "security_vpc_public_subnet_cidr2" {
  description = "Provide the network CIDR for the public subnet2 in security vpc"
  default = "10.0.2.0/24"
}
variable "security_vpc_private_subnet_cidr1" {
  description = "Provide the network CIDR for the private subnet1 in security vpc"
  default = "10.0.3.0/24"
}
variable "security_vpc_private_subnet_cidr2" {
  description = "Provide the network CIDR for the private subnet2 in security vpc"
  default = "10.0.4.0/24"
}
variable "security_vpc_gwlb_subnet_cidr1" {
  description = "Provide the network CIDR for the gwlb and endpoint subnet1 in security vpc"
  default = "10.0.5.0/24"
}
variable "security_vpc_gwlb_subnet_cidr2" {
  description = "Provide the network CIDR for the gwlbe endpoint subnet2 in security vpc"
  default = "10.0.6.0/24"
}
variable "security_vpc_tgwattach_subnet_cidr1" {
  description = "Provide the network CIDR for the tgwattach subnet1 in security vpc"
  default = "10.0.7.0/24"
}
variable "security_vpc_tgwattach_subnet_cidr2" {
  description = "Provide the network CIDR for the tgwattach subnet2 in security vpc"
  default = "10.0.8.0/24"
}
variable "spoke_vpc1_cidr" {
  description = "Provide the network CIDR for the VPC"
  default = "10.1.0.0/16"
}
variable "spoke_vpc1_public_subnet_cidr1" {
  description = "Provide the network CIDR for the public subnet1 in spoke vpc1"
  default = "10.1.1.0/24"
}
variable "spoke_vpc1_public_subnet_cidr2" {
  description = "Provide the network CIDR for the public subnet2 in spoke vpc1"
  default = "10.1.2.0/24"
}
variable "spoke_vpc1_private_subnet_cidr1" {
  description = "Provide the network CIDR for the private subnet1 in spoke vpc1"
  default = "10.1.3.0/24"
}
variable "spoke_vpc1_private_subnet_cidr2" {
  description = "Provide the network CIDR for the private subnet2 in spoke vpc1"
  default = "10.1.4.0/24"
}
variable "spoke_vpc1_gwlb_subnet_cidr1" {
  description = "Provide the network CIDR for the gwlb endpoint subnet1 in spoke vpc1"
  default = "10.1.5.0/24"
}
variable "spoke_vpc1_gwlb_subnet_cidr2" {
  description = "Provide the network CIDR for the gwlb endpoint subnet2 in spoke vpc1"
  default = "10.1.6.0/24"
}
variable "spoke_vpc2_cidr" {
  description = "Provide the network CIDR for the VPC"
  default = "10.2.0.0/16"
}
variable "spoke_vpc2_public_subnet_cidr1" {
  description = "Provide the network CIDR for the public subnet1 in spoke vpc2"
  default = "10.2.1.0/24"
}
variable "spoke_vpc2_public_subnet_cidr2" {
  description = "Provide the network CIDR for the public subnet2 in spoke vpc2"
  default = "10.2.2.0/24"
}
variable "spoke_vpc2_private_subnet_cidr1" {
  description = "Provide the network CIDR for the private subnet1 in spoke vpc2"
  default = "10.2.3.0/24"
}
variable "spoke_vpc2_private_subnet_cidr2" {
  description = "Provide the network CIDR for the private subnet2 in spoke vpc2"
  default = "10.2.4.0/24"
}
variable "spoke_vpc2_gwlb_subnet_cidr1" {
  description = "Provide the network CIDR for the gwlb endpoint subnet1 in spoke vpc2"
  default = "10.2.5.0/24"
}
variable "spoke_vpc2_gwlb_subnet_cidr2" {
  description = "Provide the network CIDR for the gwlb endpoint subnet2 in spoke vpc2"
  default = "10.2.6.0/24"
}
variable "instance_type" {
  description = "Provide the instance type for the FortiGate instances"
  default = "c5.xlarge"
}
variable "keypair" {
  description = "Provide a keypair for accessing the FortiGate instances"
  default = "kp-poc-common"
}
variable "cidr_for_access" {
  description = "Provide a network CIDR for accessing the FortiGate instances"
  default = "0.0.0.0/0"
}
variable "license_type" {
  description = "Provide the license type for the FortiGate instances, byol or ond"
  default = "ond"
}
variable "fgt1_byol_license" {
  description = "Provide the BYOL license filename for fgt1 and place the file in the root module folder"
  default = ""
}
variable "fgt2_byol_license" {
  description = "Provide the BYOL license filename for fgt2 and place the file in the root module folder"
  default = ""
}
variable "fgt1_public_ip" {
  description = "Provide the IP address in CIDR form for the public interface of fgt1 (IP from security_vpc_public_subnet)"
  default = "10.0.1.11/24"
}
variable "fgt1_private_ip" {
  description = "Provide the IP address in CIDR form for the private interface of fgt1 (IP from security_vpc_private_subnet)"
  default = "10.0.3.11/24"
}
variable "fgt2_public_ip" {
  description = "Provide the IP address in CIDR form for the public interface of fgt2 (IP from security_vpc_public_subnet)"
  default = "10.0.2.11/24"
}
variable "fgt2_private_ip" {
  description = "Provide the IP address in CIDR form for the private interface of fgt2 (IP from security_vpc_private_subnet)"
  default = "10.0.4.11/24"
}
variable "web_instance_type" {
  description = "Provide the instance type for the web server instances"
  default = "t2.micro"
}
variable "web_app1_name" {
  description = "Provide a unique web app name used for HTTP path routing"
  default = "app1"
}
variable "web_app2_name" {
  description = "Provide a unique web app name used for HTTP path routing"
  default = "app2"
}
variable "elb_app1_targetgroup_port" {
  description = "Specify the tcp port for the elb for the health checks"
  default = "8001"
}
variable "elb_app2_targetgroup_port" {
  description = "Specify the tcp port for the elb for the health checks"
  default = "8002"
}
variable "elb_listner_port" {
  description = "Specify the tcp port for the elb for the listner"
  default = "80"
}
variable "elb_type" {
  description = "Specify the elb type if one is desired, nlb or alb"
  default = "automatically handled by terraform modules"
}
variable "elb_internal" {
  description = "Specify if the elb will be private or public, true or false"
  default = "automatically handled by terraform modules"
}
variable "spoke1_nlb_dns" {
  description = "Specify the DNS record for the spoke1 vpc nlb"
  default = "automatically handled by terraform modules"
}
variable "spoke2_nlb_dns" {
  description = "Specify the DNS record for the spoke1 vpc nlb"
  default = "automatically handled by terraform modules"
}
variable "tag_name_prefix" {
  description = "Provide a common tag prefix value that will be used in the name tag for all resources"
  default = "stack-1"
}
variable "tag_name_unique" {
  description = "Provide a unique tag prefix value that will be used in the name tag for each modules resources"
  default = "automatically handled by terraform modules"
}
variable "fortigate_admin_password" {
  description = "Fortigate admin password"
}