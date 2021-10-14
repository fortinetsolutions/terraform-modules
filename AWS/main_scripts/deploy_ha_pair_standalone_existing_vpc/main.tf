
provider "aws" {
  region     = var.aws_region
}

data "template_file" "fgt_userdata_byol1" {
  template = file("./config_templates/fgt-userdata-byol.tpl")

  vars = {
    fgt_id                = var.fortigate_hostname_1
    Port1IP               = var.public1_ip_address
    Port2IP               = var.private1_ip_address
    Port3IP               = var.sync_subnet_ip_address_1
    Port4IP               = var.ha_subnet_ip_address_1
    PrivateSubnet         = var.private_subnet_cidr_1
    spoke1_cidr           = var.vpc_cidr_east
    spoke2_cidr           = var.vpc_cidr_west
    mgmt_cidr             = var.ha_subnet_cidr_1
    mgmt_gw               = cidrhost(var.ha_subnet_cidr_1, 1)
    fgt_priority          = "255"
    fgt_ha_password       = var.fgt_ha_password
    fgt_byol_license      = file("${path.module}/${var.fgt_byol_1_license}")
    fgt-remote-heartbeat  = var.sync_subnet_ip_address_2
    PublicSubnetRouterIP  = cidrhost(var.public_subnet_cidr1, 1)
    public_subnet_mask    = cidrnetmask(var.public_subnet_cidr1)
    private_subnet_mask   = cidrnetmask(var.private_subnet_cidr_1)
    sync_subnet_mask      = cidrnetmask(var.sync_subnet_cidr_1)
    hamgmt_subnet_mask    = cidrnetmask(var.ha_subnet_cidr_1)
    PrivateSubnetRouterIP = cidrhost(var.private_subnet_cidr_1, 1)
    fgt_admin_password    = var.fgt_admin_password
  }
}

data "template_file" "fgt_userdata_byol2" {
  template = file("./config_templates/fgt-userdata-byol.tpl")

  vars = {
    fgt_id                = var.fortigate_hostname_2
    Port1IP               = var.public2_ip_address
    Port2IP               = var.private2_ip_address
    Port3IP               = var.sync_subnet_ip_address_2
    Port4IP               = var.ha_subnet_ip_address_2
    PrivateSubnet         = var.private_subnet_cidr_2
    spoke1_cidr           = var.vpc_cidr_east
    spoke2_cidr           = var.vpc_cidr_west
    mgmt_cidr             = var.ha_subnet_cidr_2
    mgmt_gw               = cidrhost(var.ha_subnet_cidr_2, 1)
    fgt_priority          = "100"
    fgt_ha_password       = var.fgt_ha_password
    fgt_byol_license      = file("${path.module}/${var.fgt_byol_2_license}")
    fgt-remote-heartbeat  = var.sync_subnet_ip_address_1
    PublicSubnetRouterIP  = cidrhost(var.public_subnet_cidr2, 1)
    public_subnet_mask    = cidrnetmask(var.public_subnet_cidr2)
    private_subnet_mask   = cidrnetmask(var.private_subnet_cidr_2)
    sync_subnet_mask      = cidrnetmask(var.sync_subnet_cidr_2)
    hamgmt_subnet_mask    = cidrnetmask(var.ha_subnet_cidr_2)
    PrivateSubnetRouterIP = cidrhost(var.private_subnet_cidr_2, 1)
    fgt_admin_password    = var.fgt_admin_password
  }
}

data "template_file" "fgt_userdata_paygo1" {
  template = file("./config_templates/fgt-userdata-paygo.tpl")

  vars = {
    fgt_id                = var.fortigate_hostname_1
    Port1IP               = var.public1_ip_address
    Port2IP               = var.private1_ip_address
    Port3IP               = var.sync_subnet_ip_address_1
    Port4IP               = var.ha_subnet_ip_address_1
    PrivateSubnet         = var.private_subnet_cidr_1
    spoke1_cidr           = var.vpc_cidr_east
    spoke2_cidr           = var.vpc_cidr_west
    mgmt_cidr             = var.ha_subnet_cidr_1
    mgmt_gw               = cidrhost(var.ha_subnet_cidr_1, 1)
    fgt_priority          = "255"
    fgt_ha_password       = var.fgt_ha_password
    fgt-remote-heartbeat  = var.sync_subnet_ip_address_2
    PublicSubnetRouterIP  = cidrhost(var.public_subnet_cidr1, 1)
    public_subnet_mask    = cidrnetmask(var.public_subnet_cidr1)
    private_subnet_mask   = cidrnetmask(var.private_subnet_cidr_1)
    sync_subnet_mask      = cidrnetmask(var.sync_subnet_cidr_1)
    hamgmt_subnet_mask    = cidrnetmask(var.ha_subnet_cidr_1)
    PrivateSubnetRouterIP = cidrhost(var.private_subnet_cidr_1, 1)
    fgt_admin_password    = var.fgt_admin_password
  }
}

data "template_file" "fgt_userdata_paygo2" {
  template = file("./config_templates/fgt-userdata-paygo.tpl")

  vars = {
    fgt_id                = var.fortigate_hostname_2
    Port1IP               = var.public2_ip_address
    Port2IP               = var.private2_ip_address
    Port3IP               = var.sync_subnet_ip_address_2
    Port4IP               = var.ha_subnet_ip_address_2
    PrivateSubnet         = var.private_subnet_cidr_2
    spoke1_cidr           = var.vpc_cidr_east
    spoke2_cidr           = var.vpc_cidr_west
    mgmt_cidr             = var.ha_subnet_cidr_2
    mgmt_gw               = cidrhost(var.ha_subnet_cidr_2, 1)
    fgt_priority          = "100"
    fgt_ha_password       = var.fgt_ha_password
    fgt-remote-heartbeat  = var.sync_subnet_ip_address_1
    PublicSubnetRouterIP  = cidrhost(var.public_subnet_cidr2, 1)
    public_subnet_mask    = cidrnetmask(var.public_subnet_cidr2)
    private_subnet_mask   = cidrnetmask(var.private_subnet_cidr_2)
    sync_subnet_mask      = cidrnetmask(var.sync_subnet_cidr_2)
    hamgmt_subnet_mask    = cidrnetmask(var.ha_subnet_cidr_2)
    PrivateSubnetRouterIP = cidrhost(var.private_subnet_cidr_2, 1)
    fgt_admin_password    = var.fgt_admin_password
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
module "allow_private_subnets" {
  source = "../../modules/security_group"
  access_key              = var.access_key
  secret_key              = var.secret_key
  aws_region              = var.aws_region
  vpc_id                  = var.vpc_id
  name                    = "${var.fortigate_sg_name} Allow Private Subnets"
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
  access_key              = var.access_key
  secret_key              = var.secret_key
  aws_region              = var.aws_region
  vpc_id                  = var.vpc_id
  name                    = "${var.fortigate_sg_name} Allow Public Subnets"
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

module "sync-subnet-1" {
  source = "../../modules/subnet"

  access_key                 = var.access_key
  secret_key                 = var.secret_key
  aws_region                 = var.aws_region
  environment                = var.environment
  customer_prefix            = var.customer_prefix
  vpc_id                     = var.vpc_id
  availability_zone          = var.availability_zone_1
  subnet_cidr                = var.sync_subnet_cidr_1
  subnet_description         = var.sync_description_1
}

module "sync-subnet-2" {
  source = "../../modules/subnet"

  access_key                 = var.access_key
  secret_key                 = var.secret_key
  aws_region                 = var.aws_region
  environment                = var.environment
  customer_prefix            = var.customer_prefix
  vpc_id                     = var.vpc_id
  availability_zone          = var.availability_zone_2
  subnet_cidr                = var.sync_subnet_cidr_2
  subnet_description         = var.sync_description_2
}

module "ha-subnet-1" {
  source = "../../modules/subnet"

  access_key                 = var.access_key
  secret_key                 = var.secret_key
  aws_region                 = var.aws_region
  environment                = var.environment
  customer_prefix            = var.customer_prefix
  vpc_id                     = var.vpc_id
  availability_zone          = var.availability_zone_1
  subnet_cidr                = var.ha_subnet_cidr_1
  subnet_description         = var.ha_description_1
  public_route               = 1
  public_route_table_id      = var.public_route_table_id
}

module "ha-subnet-2" {
  source = "../../modules/subnet"

  access_key                 = var.access_key
  secret_key                 = var.secret_key
  aws_region                 = var.aws_region
  environment                = var.environment
  customer_prefix            = var.customer_prefix
  vpc_id                     = var.vpc_id
  availability_zone          = var.availability_zone_2
  subnet_cidr                = var.ha_subnet_cidr_2
  subnet_description         = var.ha_description_2
  public_route               = 1
  public_route_table_id      = var.public_route_table_id
}

#
# Fortigate HA Pair and IAM Profiles
#
module "iam_profile" {
  source = "../../modules/fortigate_ha_instance_iam_role"

  access_key                  = var.access_key
  secret_key                  = var.secret_key
  aws_region                  = var.aws_region
  customer_prefix             = var.customer_prefix
  environment                 = var.environment
}

module "fortigate_1" {
  source                      = "../../modules/ec2_instance"

  access_key                  = var.access_key
  secret_key                  = var.secret_key
  aws_region                  = var.aws_region
  availability_zone           = var.availability_zone_1
  customer_prefix             = var.customer_prefix
  environment                 = var.environment
  enable_private_interface    = true
  enable_sync_interface       = true
  enable_hamgmt_interface     = true
  enable_public_ips           = true
  enable_mgmt_public_ips      = true
  public_subnet_id            = var.public1_subnet_id
  public_ip_address           = var.public1_ip_address
  private_subnet_id           = var.private1_subnet_id
  private_ip_address          = var.private1_ip_address
  sync_subnet_id              = module.sync-subnet-1.id
  sync_ip_address             = var.sync_subnet_ip_address_1
  ha_subnet_id                = module.ha-subnet-1.id
  ha_ip_address               = var.ha_subnet_ip_address_1
  aws_ami                     = var.use_fortigate_byol ? data.aws_ami.fortigate_byol.id : data.aws_ami.fortigate_paygo.id
  keypair                     = var.keypair
  instance_type               = var.fortigate_instance_type
  instance_name               = var.fortigate_instance_name_1
  security_group_private_id   = module.allow_private_subnets.id
  security_group_public_id    = module.allow_public_subnets.id
  acl                         = var.acl
  iam_instance_profile_id     = module.iam_profile.id
  userdata_rendered           = var.use_fortigate_byol ? data.template_file.fgt_userdata_byol1.rendered : data.template_file.fgt_userdata_paygo1.rendered
}

module "fortigate_2" {
  source                      = "../../modules/ec2_instance"

  access_key                  = var.access_key
  secret_key                  = var.secret_key
  aws_region                  = var.aws_region
  availability_zone           = var.availability_zone_2
  customer_prefix             = var.customer_prefix
  environment                 = var.environment
  enable_private_interface    = true
  enable_sync_interface       = true
  enable_hamgmt_interface     = true
  enable_public_ips           = false
  enable_mgmt_public_ips      = true
  public_subnet_id            = var.public2_subnet_id
  public_ip_address           = var.public2_ip_address
  private_subnet_id           = var.private2_subnet_id
  private_ip_address          = var.private2_ip_address
  sync_subnet_id              = module.sync-subnet-2.id
  sync_ip_address             = var.sync_subnet_ip_address_2
  ha_subnet_id                = module.ha-subnet-2.id
  ha_ip_address               = var.ha_subnet_ip_address_2
  aws_ami                     = var.use_fortigate_byol ? data.aws_ami.fortigate_byol.id : data.aws_ami.fortigate_paygo.id
  keypair                     = var.keypair
  instance_type               = var.fortigate_instance_type
  instance_name               = var.fortigate_instance_name_2
  security_group_private_id   = module.allow_private_subnets.id
  security_group_public_id    = module.allow_public_subnets.id
  acl                         = var.acl
  iam_instance_profile_id     = module.iam_profile.id
  userdata_rendered           = var.use_fortigate_byol ? data.template_file.fgt_userdata_byol2.rendered : data.template_file.fgt_userdata_paygo2.rendered
}
