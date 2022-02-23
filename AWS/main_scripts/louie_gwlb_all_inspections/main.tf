provider "aws" {
  region = var.region
}

module "transit-gw" {
  source = ".//modules/vpc/tgw"
  region = var.region
  tag_name_prefix = var.tag_name_prefix
}

module "security-vpc" {
  source = ".//modules/vpc/vpc-security-tgw"
  region = var.region
  
  availability_zone1 = var.availability_zone1
  availability_zone2 = var.availability_zone2
  vpc_cidr = var.security_vpc_cidr
  public_subnet_cidr1 = var.security_vpc_public_subnet_cidr1
  public_subnet_cidr2 = var.security_vpc_public_subnet_cidr2
  private_subnet_cidr1 = var.security_vpc_private_subnet_cidr1
  private_subnet_cidr2 = var.security_vpc_private_subnet_cidr2
  gwlb_subnet_cidr1 = var.security_vpc_gwlb_subnet_cidr1
  gwlb_subnet_cidr2 = var.security_vpc_gwlb_subnet_cidr2
  tgwattach_subnet_cidr1 = var.security_vpc_tgwattach_subnet_cidr1
  tgwattach_subnet_cidr2 = var.security_vpc_tgwattach_subnet_cidr2
  transit_gateway_id = module.transit-gw.tgw_id
  tgw_spoke_route_table_id = module.transit-gw.tgw_spoke_route_table_id
  tgw_security_route_table_id = module.transit-gw.tgw_security_route_table_id
  gwlb_endpoint_service_name = module.security-vpc-gwlb.gwlb_endpoint_service_name
  gwlb_endpoint_service_type = module.security-vpc-gwlb.gwlb_endpoint_service_type
  tag_name_prefix = var.tag_name_prefix
  tag_name_unique = "security"
}

module "spoke-vpc1" {
  source = ".//modules/vpc/vpc-spoke-tgw"
  region = var.region
  
  availability_zone1 = var.availability_zone1
  availability_zone2 = var.availability_zone2
  vpc_cidr = var.spoke_vpc1_cidr
  public_subnet_cidr1 = var.spoke_vpc1_public_subnet_cidr1
  public_subnet_cidr2 = var.spoke_vpc1_public_subnet_cidr2
  private_subnet_cidr1 = var.spoke_vpc1_private_subnet_cidr1
  private_subnet_cidr2 = var.spoke_vpc1_private_subnet_cidr2
  gwlb_subnet_cidr1 = var.spoke_vpc1_gwlb_subnet_cidr1
  gwlb_subnet_cidr2 = var.spoke_vpc1_gwlb_subnet_cidr2
  transit_gateway_id = module.transit-gw.tgw_id
  tgw_spoke_route_table_id = module.transit-gw.tgw_spoke_route_table_id
  tgw_security_route_table_id = module.transit-gw.tgw_security_route_table_id
  gwlb_endpoint_service_name = module.security-vpc-gwlb.gwlb_endpoint_service_name
  gwlb_endpoint_service_type = module.security-vpc-gwlb.gwlb_endpoint_service_type
  tag_name_prefix = var.tag_name_prefix
  tag_name_unique = "spoke1"
}

module "spoke-vpc2" {
  source = ".//modules/vpc/vpc-spoke-tgw"
  region = var.region
  
  availability_zone1 = var.availability_zone1
  availability_zone2 = var.availability_zone2
  vpc_cidr = var.spoke_vpc2_cidr
  public_subnet_cidr1 = var.spoke_vpc2_public_subnet_cidr1
  public_subnet_cidr2 = var.spoke_vpc2_public_subnet_cidr2
  private_subnet_cidr1 = var.spoke_vpc2_private_subnet_cidr1
  private_subnet_cidr2 = var.spoke_vpc2_private_subnet_cidr2
  gwlb_subnet_cidr1 = var.spoke_vpc2_gwlb_subnet_cidr1
  gwlb_subnet_cidr2 = var.spoke_vpc2_gwlb_subnet_cidr2
  transit_gateway_id = module.transit-gw.tgw_id
  tgw_spoke_route_table_id = module.transit-gw.tgw_spoke_route_table_id
  tgw_security_route_table_id = module.transit-gw.tgw_security_route_table_id
  gwlb_endpoint_service_name = module.security-vpc-gwlb.gwlb_endpoint_service_name
  gwlb_endpoint_service_type = module.security-vpc-gwlb.gwlb_endpoint_service_type
  tag_name_prefix = var.tag_name_prefix
  tag_name_unique = "spoke2"
}

module "security-vpc-gwlb" {
  source = ".//modules/vpc/gwlb"
  region = var.region
  
  elb_type = "gateway"
  elb_internal = "true"
  elb_listner_port = var.elb_listner_port
  vpc_id = module.security-vpc.vpc_id
  subnet1_id = module.security-vpc.gwlb_subnet1_id
  subnet2_id = module.security-vpc.gwlb_subnet2_id
  instance1_id = module.fgcp-ha.fgt1_id
  instance2_id = module.fgcp-ha.fgt2_id
  tag_name_prefix = var.tag_name_prefix
  tag_name_unique = "sec-gwlb"
}

/*
#
# commenting out this until proxy mode is supported on gwlb
#
module "security-vpc-public-alb" {
  source = ".//modules/vpc/elb"
  region = var.region
  
  elb_type = "alb"
  elb_internal = "false"
  elb_listner_port = var.elb_listner_port
  web_app1_name = var.web_app1_name
  web_app2_name = var.web_app2_name
  elb_app1_targetgroup_port = var.elb_app1_targetgroup_port
  elb_app2_targetgroup_port = var.elb_app2_targetgroup_port
  vpc_id = module.security-vpc.vpc_id
  subnet1_id = module.security-vpc.public_subnet1_id
  subnet2_id = module.security-vpc.public_subnet2_id
  instance1_id = module.fgcp-ha.fgt1_id
  instance2_id = module.fgcp-ha.fgt2_id
  tag_name_prefix = var.tag_name_prefix
  tag_name_unique = "sec-pub-alb"
}
*/

module "spoke1-vpc-public-nlb" {
  source = ".//modules/vpc/elb"
  region = var.region
  
  elb_type = "nlb"
  elb_internal = "false"
  elb_listner_port = var.elb_listner_port
  vpc_id = module.spoke-vpc1.vpc_id
  subnet1_id = module.spoke-vpc1.public_subnet1_id
  subnet2_id = module.spoke-vpc1.public_subnet2_id
  instance1_id = module.spoke1-web1.web_id
  instance2_id = module.spoke1-web2.web_id
  tag_name_prefix = var.tag_name_prefix
  tag_name_unique = "spoke1-public-nlb"
}

module "spoke2-vpc-public-nlb" {
  source = ".//modules/vpc/elb"
  region = var.region
  
  elb_type = "nlb"
  elb_internal = "false"
  elb_listner_port = var.elb_listner_port
  vpc_id = module.spoke-vpc2.vpc_id
  subnet1_id = module.spoke-vpc2.public_subnet1_id
  subnet2_id = module.spoke-vpc2.public_subnet2_id
  instance1_id = module.spoke2-web1.web_id
  instance2_id = module.spoke2-web2.web_id
  tag_name_prefix = var.tag_name_prefix
  tag_name_unique = "spoke2-public-nlb"
}

module "spoke1-web1" {
  source = ".//modules/vpc/web-server"
  region = var.region

  availability_zone = var.availability_zone1
  vpc_id = module.spoke-vpc1.vpc_id
  subnet_id = module.spoke-vpc1.private_subnet1_id

  keypair = var.keypair  
  instance_type = var.web_instance_type
  web_app_name = var.web_app1_name
  tag_name_prefix = var.tag_name_prefix
  tag_name_unique = "spoke1-web1"
}

module "spoke1-web2" {
  source = ".//modules/vpc/web-server"
  region = var.region

  availability_zone = var.availability_zone2
  vpc_id = module.spoke-vpc1.vpc_id
  subnet_id = module.spoke-vpc1.private_subnet2_id

  keypair = var.keypair  
  instance_type = var.web_instance_type
  web_app_name = var.web_app1_name
  tag_name_prefix = var.tag_name_prefix
  tag_name_unique = "spoke1-web2"
}

module "spoke2-web1" {
  source = ".//modules/vpc/web-server"
  region = var.region

  availability_zone = var.availability_zone1
  vpc_id = module.spoke-vpc2.vpc_id
  subnet_id = module.spoke-vpc2.private_subnet1_id

  keypair = var.keypair  
  instance_type = var.web_instance_type
  web_app_name = var.web_app2_name
  tag_name_prefix = var.tag_name_prefix
  tag_name_unique = "spoke2-web1"
}

module "spoke2-web2" {
  source = ".//modules/vpc/web-server"
  region = var.region

  availability_zone = var.availability_zone2
  vpc_id = module.spoke-vpc2.vpc_id
  subnet_id = module.spoke-vpc2.private_subnet2_id

  keypair = var.keypair  
  instance_type = var.web_instance_type
  web_app_name = var.web_app2_name
  tag_name_prefix = var.tag_name_prefix
  tag_name_unique = "spoke2-web2"
}

module "fgcp-ha" {
  source = ".//modules/ftnt_aws/fgt/2instances"
  region = var.region

  availability_zone1 = var.availability_zone1
  availability_zone2 = var.availability_zone2
  vpc_id = module.security-vpc.vpc_id
  vpc_cidr = var.security_vpc_cidr
  public_subnet1_id = module.security-vpc.public_subnet1_id
  public_subnet2_id = module.security-vpc.public_subnet2_id
  fgt1_public_ip = var.fgt1_public_ip
  fgt2_public_ip = var.fgt2_public_ip
  gwlb_ip1 = module.security-vpc-gwlb.gwlb_ip1
  gwlb_ip2 = module.security-vpc-gwlb.gwlb_ip2

  keypair = var.keypair  
  cidr_for_access = var.cidr_for_access
  instance_type = var.instance_type
  license_type = var.license_type
  fgt1_byol_license = var.fgt1_byol_license
  fgt2_byol_license = var.fgt2_byol_license
  fortigate_admin_password = var.fortigate_admin_password
  tag_name_prefix = var.tag_name_prefix
}

