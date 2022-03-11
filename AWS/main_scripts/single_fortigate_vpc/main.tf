
provider "aws" {
  region     = var.aws_region
}

#
# Local variables for splitting up the subnets and assigning host IP's from within the cidr block
#
locals {
  availability_zone = "${var.aws_region}${var.availability_zone}"
}
locals {
  fortigate_sg_name = "${var.customer_prefix}-${var.environment}-fgt-sg"
}
locals {
  public_subnet_index = 0
}
locals {
  private_subnet_index = 1
}
locals {
  public_subnet_cidr = cidrsubnet(var.cidr_block, 8, local.public_subnet_index)
}
locals {
  private_subnet_cidr = cidrsubnet(var.cidr_block, 8, local.private_subnet_index)
}
locals {
  fortigate_public_ip = cidrhost(local.public_subnet_cidr, var.fortigate_host_ip)
}
locals {
  fortigate_private_ip = cidrhost(local.private_subnet_cidr, var.fortigate_host_ip)
}

#
# AMI to be used by the BYOL instance of Fortigate]
# Change the foritos_version and the use_fortigate_byol variables in terraform.tfvars to change it
#
data "aws_ami" "fortigate_byol" {
  most_recent = true

  filter {
    name                         = "name"
    values                       = ["FortiGate-VM64-AWS * (${var.fortios_version}) GA*"]
  }

  filter {
    name                         = "virtualization-type"
    values                       = ["hvm"]
  }

  owners                         = ["679593333241"] # Canonical
}

#
# AMI to be used by the PAYGO instance of Fortigate
# Change the foritos_version and the use_fortigate_byol variables in terraform.tfvars to change it
#
data "aws_ami" "fortigate_paygo" {
  most_recent = true

  filter {
    name                         = "name"
    values                       = ["FortiGate-VM64-AWSONDEMAND * (${var.fortios_version}) GA*"]
  }

  filter {
    name                         = "virtualization-type"
    values                       = ["hvm"]
  }

  owners                         = ["679593333241"] # Canonical
}


data "template_file" "fgt_userdata_byol" {
  template = file("./config_templates/fgt-userdata-byol.tpl")

  vars = {
    fgt_id                = var.fortigate_instance_name
    Port1IP               = local.fortigate_public_ip
    Port2IP               = local.fortigate_private_ip
    PrivateSubnet         = local.private_subnet_cidr
    security_cidr         = var.cidr_block
    PublicSubnetRouterIP  = cidrhost(local.public_subnet_cidr, 1)
    public_subnet_mask    = cidrnetmask(local.public_subnet_cidr)
    private_subnet_mask   = cidrnetmask(local.private_subnet_cidr)
    PrivateSubnetRouterIP = cidrhost(local.private_subnet_cidr, 1)
    fgt_admin_password    = var.fgt_admin_password
    fgt_byol_license      = var.fgt_byol_license
  }
}

data "template_file" "fgt_userdata_paygo" {
  template = file("./config_templates/fgt-userdata-paygo.tpl")

  vars = {
    fgt_id                = var.fortigate_instance_name
    Port1IP               = local.fortigate_public_ip
    Port2IP               = local.fortigate_private_ip
    PrivateSubnet         = local.private_subnet_cidr
    security_cidr         = var.cidr_block
    public_subnet_mask    = cidrnetmask(local.public_subnet_cidr)
    private_subnet_mask   = cidrnetmask(local.private_subnet_cidr)
    fgt_admin_password    = var.fgt_admin_password
  }
}


#
# Fortigate HA Pair and IAM Profiles
#
module "iam_profile" {
  source = "../../modules/fortigate_ha_instance_iam_role"

  aws_region                  = var.aws_region
  customer_prefix             = var.customer_prefix
  environment                 = var.environment
}

#
# This is an "allow all" security group, but a place holder for a more strict SG
#
module "allow_private_subnets" {
  source = "../../modules/security_group"
  aws_region              = var.aws_region
  vpc_id                  = module.base-vpc.vpc_id
  name                    = "${local.fortigate_sg_name} Allow Private Subnets"
  ingress_to_port         = 0
  ingress_from_port       = 0
  ingress_protocol        = "-1"
  ingress_cidr_for_access = "0.0.0.0/0"
  egress_to_port          = 0
  egress_from_port        = 0
  egress_protocol         = "-1"
  egress_cidr_for_access  = "0.0.0.0/0"
  customer_prefix         = var.customer_prefix
  environment             = var.environment
}

#
# This is an "allow all" security group, but a place holder for a more strict SG
#
module "allow_public_subnets" {
  source = "../../modules/security_group"
  aws_region              = var.aws_region
  vpc_id                  = module.base-vpc.vpc_id
  name                    = "${local.fortigate_sg_name} Allow Public Subnets"
  ingress_to_port         = 0
  ingress_from_port       = 0
  ingress_protocol        = "-1"
  ingress_cidr_for_access = "0.0.0.0/0"
  egress_to_port          = 0
  egress_from_port        = 0
  egress_protocol         = "-1"
  egress_cidr_for_access  = "0.0.0.0/0"
  customer_prefix         = var.customer_prefix
  environment             = var.environment
}

module "base-vpc" {
  source = "../../main_scripts/base_vpc_single_az"

  aws_region                 = var.aws_region
  environment                = var.environment
  customer_prefix            = var.customer_prefix
  availability_zone          = local.availability_zone
  public_subnet_cidr         = local.public_subnet_cidr
  public_description         = "public"
  private_subnet_cidr        = local.private_subnet_cidr
  private_description        = "private"
  vpc_name                   = "base"
  vpc_cidr                   = var.cidr_block

}

resource "aws_default_route_table" "default_route" {
  default_route_table_id = module.base-vpc.vpc_main_route_table_id
  tags = {
    Name = "default table for base vpc (unused)"
  }
}


module "fortigate" {
  source                      = "../../modules/ec2_instance"

  aws_region                  = var.aws_region
  availability_zone           = local.availability_zone
  customer_prefix             = var.customer_prefix
  environment                 = var.environment
  enable_private_interface    = true
  enable_sync_interface       = false
  enable_hamgmt_interface     = false
  enable_public_ips           = true
  enable_mgmt_public_ips      = false
  public_subnet_id            = module.base-vpc.public_subnet_id
  public_ip_address           = local.fortigate_public_ip
  private_subnet_id           = module.base-vpc.private_subnet_id
  private_ip_address          = local.fortigate_private_ip
  aws_ami                     = var.use_fortigate_byol ? data.aws_ami.fortigate_byol.id : data.aws_ami.fortigate_paygo.id
  keypair                     = var.keypair
  instance_type               = var.fortigate_instance_type
  instance_name               = var.fortigate_instance_name
  security_group_private_id   = module.allow_private_subnets.id
  security_group_public_id    = module.allow_public_subnets.id
  acl                         = var.acl
  iam_instance_profile_id     = module.iam_profile.id
  userdata_rendered           = var.use_fortigate_byol ? data.template_file.fgt_userdata_byol.rendered : data.template_file.fgt_userdata_paygo.rendered
}

#
# Point the private route table default route to the Fortigate Private ENI
#
resource "aws_route" "private" {
  route_table_id         = module.base-vpc.private_route_table_id
  destination_cidr_block = "0.0.0.0/0"
  network_interface_id   = module.fortigate.network_private_interface_id[0]
}


module "private_route_table_association" {
  source                     = "../../modules/route_table_association"
  aws_region                 = var.aws_region
  customer_prefix            = var.customer_prefix
  environment                = var.environment
  subnet_ids                 = module.base-vpc.private_subnet_id
  route_table_id             = module.base-vpc.private_route_table_id
}