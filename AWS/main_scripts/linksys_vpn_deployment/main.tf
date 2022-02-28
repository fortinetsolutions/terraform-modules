
provider "aws" {
  region     = var.aws_region
}

#
# Allocate the eip's up front, so the public IP information can be used to build the swan/fortigate vpn configuration
#
resource "aws_eip" "swan_eip" {
  vpc = true
}

resource "aws_eip_association" "swan_eip_association" {
  depends_on             = [ module.swan_instance ]
  network_interface_id   = module.swan_instance.network_public_interface_id
  allocation_id          = aws_eip.swan_eip.id
}

resource "aws_eip" "fgt_eip" {
  vpc = true
}

resource "aws_eip_association" "fgt_eip_association" {
  depends_on             = [ module.fortigate ]
  network_interface_id   = module.fortigate.network_public_interface_id
  allocation_id          = aws_eip.fgt_eip.id
}

#
# Templates for Fortigate Configuration
#
data "template_file" "fgt_userdata_byol" {
  template = file("./config_templates/fgt-userdata-byol.tpl")
  depends_on              = [ aws_eip.fgt_eip, aws_eip.swan_eip ]

  vars = {
    fgt_id                = var.fortigate_hostname
    Port1IP               = var.fortigate_public_ip_address
    Port2IP               = var.fortigate_private_ip_address
    PrivateSubnet         = var.fortigate_private_subnet_cidr
    fgt_byol_license      = file("${path.module}/${var.fgt_byol_license}")
    PublicSubnetRouterIP  = cidrhost(var.fortigate_public_subnet_cidr, 1)
    public_subnet_mask    = cidrnetmask(var.fortigate_public_subnet_cidr)
    private_subnet_mask   = cidrnetmask(var.fortigate_private_subnet_cidr)
    PrivateSubnetRouterIP = cidrhost(var.fortigate_private_subnet_cidr, 1)
    fgt_admin_password    = var.fgt_admin_password
    swan_vpn_public_ip    = aws_eip.swan_eip.public_ip
    fgt_vpn_public_ip     = aws_eip.fgt_eip.public_ip
  }
}

data "template_file" "fgt_userdata_paygo" {
  template = file("./config_templates/fgt-userdata-paygo.tpl")

  vars = {
    fgt_id                = var.fortigate_hostname
    Port1IP               = var.fortigate_public_ip_address
    Port2IP               = var.fortigate_private_ip_address
    PrivateSubnet         = var.fortigate_private_subnet_cidr
    PublicSubnetRouterIP  = cidrhost(var.fortigate_public_subnet_cidr, 1)
    public_subnet_mask    = cidrnetmask(var.fortigate_public_subnet_cidr)
    private_subnet_mask   = cidrnetmask(var.fortigate_private_subnet_cidr)
    PrivateSubnetRouterIP = cidrhost(var.fortigate_private_subnet_cidr, 1)
    fgt_admin_password    = var.fgt_admin_password
    swan_vpn_public_ip    = aws_eip.swan_eip.public_ip
    fgt_vpn_public_ip     = aws_eip.fgt_eip.public_ip
  }
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


#
# This is an "allow all" security group, but a place holder for a more strict SG
#
module "fortigate_allow_private_subnets" {
  source = "../../modules/security_group"
  aws_region              = var.aws_region
  vpc_id                  = module.base-fortigate-vpc.vpc_id
  name                    = "${var.fortigate_sg_name} Allow Private Subnets"
  ingress_to_port         = 0
  ingress_from_port       = 0
  ingress_protocol        = "-1"
  ingress_cidr_for_access = var.cidr_for_access
  egress_to_port          = 0
  egress_from_port        = 0
  egress_protocol         = "-1"
  egress_cidr_for_access  = var.cidr_for_access
  customer_prefix         = var.fortigate_customer_prefix
  environment             = var.environment
}

#
# This is an "allow all" security group, but a place holder for a more strict SG
#
module "fortigate_allow_public_subnets" {
  source = "../../modules/security_group"
  aws_region              = var.aws_region
  vpc_id                  = module.base-fortigate-vpc.vpc_id
  name                    = "${var.fortigate_sg_name} Allow Public Subnets"
  ingress_to_port         = 0
  ingress_from_port       = 0
  ingress_protocol        = "-1"
  ingress_cidr_for_access = var.cidr_for_access
  egress_to_port          = 0
  egress_from_port        = 0
  egress_protocol         = "-1"
  egress_cidr_for_access  = var.cidr_for_access
  customer_prefix         = var.fortigate_customer_prefix
  environment             = var.environment
}


#
# Fortigate HA Pair and IAM Profiles
#
module "iam_profile" {
  source = "../../modules/fortigate_ha_instance_iam_role"

  aws_region                  = var.aws_region
  customer_prefix             = var.fortigate_customer_prefix
  environment                 = var.environment
}

module "base-fortigate-vpc" {
  source = "../../main_scripts/base_vpc_single_az"

  aws_region                 = var.aws_region
  environment                = var.environment
  customer_prefix            = var.fortigate_customer_prefix
  availability_zone          = var.fortigate_availability_zone
  public_subnet_cidr         = var.fortigate_public_subnet_cidr
  public_description         = var.fortigate_public_description
  private_subnet_cidr        = var.fortigate_private_subnet_cidr
  private_description        = var.fortigate_private_description
  vpc_name                   = var.vpc_fortigate_name
  vpc_cidr                   = var.vpc_fortigate_cidr

}

module "fortigate" {
  source                      = "../../modules/ec2_instance"
  depends_on                  = [ aws_eip.fgt_eip, aws_eip.swan_eip ]

  aws_region                  = var.aws_region
  availability_zone           = var.fortigate_availability_zone
  customer_prefix             = var.fortigate_customer_prefix
  environment                 = var.environment
  enable_private_interface    = true
  enable_public_ips           = false
  enable_sync_interface       = false
  enable_hamgmt_interface     = false
  enable_mgmt_public_ips      = false
  public_subnet_id            = module.base-fortigate-vpc.public_subnet_id
  public_ip_address           = var.fortigate_public_ip_address
  private_subnet_id           = module.base-fortigate-vpc.private_subnet_id
  private_ip_address          = var.fortigate_private_ip_address
  sync_subnet_id              = ""
  sync_ip_address             = ""
  ha_subnet_id                = ""
  ha_ip_address               = ""
  aws_ami                     = var.use_fortigate_byol ? data.aws_ami.fortigate_byol.id : data.aws_ami.fortigate_paygo.id
  keypair                     = var.keypair
  instance_type               = var.fortigate_instance_type
  instance_name               = var.fortigate_instance_name
  security_group_private_id   = module.fortigate_allow_private_subnets.id
  security_group_public_id    = module.fortigate_allow_public_subnets.id
  acl                         = var.acl
  iam_instance_profile_id     = module.iam_profile.id
  userdata_rendered           = var.use_fortigate_byol ? data.template_file.fgt_userdata_byol.rendered : data.template_file.fgt_userdata_paygo.rendered
}

#
# SWAN Side
#
data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-20211129"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
  owners = ["099720109477"] # Canonical
}

module "ec2-sg" {
  source = "../../modules/security_group"
  aws_region           = var.aws_region
  vpc_id               = module.base-swan-vpc.vpc_id
  name                 = var.swan_sg_name
  ingress_to_port         = 0
  ingress_from_port       = 0
  ingress_protocol        = "-1"
  ingress_cidr_for_access = "0.0.0.0/0"
  egress_to_port          = 0
  egress_from_port        = 0
  egress_protocol         = "-1"
  egress_cidr_for_access = "0.0.0.0/0"
  customer_prefix      = var.swan_customer_prefix
  environment          = var.environment
}

#
# IAM Profile for linux instance
#
module "linux_iam_profile" {
  source = "../../modules/ec2_instance_iam_role"

  aws_region                  = var.aws_region
  customer_prefix             = var.swan_customer_prefix
  environment                 = var.environment
}


data "template_file" "swan_userdata" {
  template = file("./config_templates/swan-userdata.tpl")
  depends_on                   = [ aws_eip.fgt_eip, aws_eip.swan_eip ]

  vars = {
    swan_protected_cidr        = var.swan_private_subnet_cidr
    fortigate_protected_cidr   = var.fortigate_private_subnet_cidr
    swan_vpn_psk               = var.swan_vpn_psk
    swan_vpn_public_ip         = aws_eip.swan_eip.public_ip
    fgt_vpn_public_ip          = aws_eip.fgt_eip.public_ip
  }
}

module "swan_allow_private_subnets" {
  source = "../../modules/security_group"
  aws_region              = var.aws_region
  vpc_id                  = module.base-fortigate-vpc.vpc_id
  name                    = "${var.fortigate_sg_name} Allow Private Subnets"
  ingress_to_port         = 0
  ingress_from_port       = 0
  ingress_protocol        = "-1"
  ingress_cidr_for_access = var.cidr_for_access
  egress_to_port          = 0
  egress_from_port        = 0
  egress_protocol         = "-1"
  egress_cidr_for_access  = var.cidr_for_access
  customer_prefix         = var.swan_customer_prefix
  environment             = var.environment
}

#
# This is an "allow all" security group, but a place holder for a more strict SG
#
module "swan_allow_public_subnets" {
  source = "../../modules/security_group"
  aws_region              = var.aws_region
  vpc_id                  = module.base-fortigate-vpc.vpc_id
  name                    = "${var.swan_sg_name} Allow Public Subnets"
  ingress_to_port         = 0
  ingress_from_port       = 0
  ingress_protocol        = "-1"
  ingress_cidr_for_access = var.cidr_for_access
  egress_to_port          = 0
  egress_from_port        = 0
  egress_protocol         = "-1"
  egress_cidr_for_access  = var.cidr_for_access
  customer_prefix         = var.swan_customer_prefix
  environment             = var.environment
}

module "base-swan-vpc" {
  source = "../../main_scripts/base_vpc_single_az"

  aws_region                 = var.aws_region
  environment                = var.environment
  customer_prefix            = var.swan_customer_prefix
  availability_zone          = var.swan_availability_zone
  public_subnet_cidr         = var.swan_public_subnet_cidr
  public_description         = var.swan_public_description
  private_subnet_cidr        = var.swan_private_subnet_cidr
  private_description        = var.swan_private_description
  vpc_name                   = var.vpc_swan_name
  vpc_cidr                   = var.vpc_swan_cidr

}

resource "aws_default_route_table" "default_route" {
  default_route_table_id = module.base-swan-vpc.vpc_main_route_table_id
  tags = {
    Name = "default table for base vpc (unused)"
  }
}


module "private_route_table_association" {
  source                     = "../../modules/route_table_association"

  aws_region                 = var.aws_region
  customer_prefix            = var.swan_customer_prefix
  environment                = var.environment
  subnet_ids                 = module.base-swan-vpc.private_subnet_id
  route_table_id             = module.base-swan-vpc.private_route_table_id
}

#
# East Linux Instance for Generating East->West Traffic
#
module "swan_instance" {
  source                      = "../../modules/ec2_instance"
  depends_on                  = [ aws_eip.fgt_eip, aws_eip.swan_eip ]

  aws_region                  = var.aws_region
  availability_zone           = var.swan_availability_zone
  customer_prefix             = var.swan_customer_prefix
  environment                 = var.environment
  enable_private_interface    = false
  enable_public_ips           = false
  enable_sync_interface       = false
  enable_hamgmt_interface     = false
  enable_mgmt_public_ips      = false
  public_subnet_id            = module.base-swan-vpc.public_subnet_id
  public_ip_address           = var.swan_public_ip_address
  private_subnet_id           = module.base-swan-vpc.private_subnet_id
  private_ip_address          = var.swan_private_ip_address
  aws_ami                     = data.aws_ami.ubuntu.id
  keypair                     = var.keypair
  instance_type               = var.swan_instance_type
  instance_name               = var.swan_instance_name
  security_group_public_id    = module.ec2-sg.id
  acl                         = var.acl
  iam_instance_profile_id     = module.linux_iam_profile.id
  userdata_rendered           = data.template_file.swan_userdata.rendered
}
