
provider "aws" {
  region     = var.aws_region
}

data "template_file" "fwb_userdata_byol_1" {
  template = file("./config_templates/fwb-userdata-byol.tpl")

  vars = {
    fwb_byol_license      = file("${path.module}/${var.fwb_byol_license_1}")
    fwb_admin_password    = var.fwb_admin_password
    fwb_s3_bucket         = var.fwb_s3_bucket
    fwb_aws_region        = var.aws_region
    fwb_license_file      = var.fwb_byol_license_1
  }
}

data "template_file" "fwb_userdata_byol_2" {
  template = file("./config_templates/fwb-userdata-byol.tpl")

  vars = {
    fwb_byol_license      = file("${path.module}/${var.fwb_byol_license_2}")
    fwb_admin_password    = var.fwb_admin_password
    fwb_s3_bucket         = var.fwb_s3_bucket
    fwb_aws_region        = var.aws_region
    fwb_license_file      = var.fwb_byol_license_2
  }
}
/*

data "template_file" "fwb_userdata_paygo_1" {
  template = file("./config_templates/fwb-userdata-paygo.tpl")

  vars = {
    fwb_admin_password     = var.fwb_admin_password
    fwb_s3_bucket          = var.fwb_s3_bucket
    fwb_aws_region         = var.aws_region
  }
}


data "template_file" "fwb_userdata_paygo_2" {
  template = file("./config_templates/fwb-userdata-paygo.tpl")

  vars = {
    fwb_admin_password     = var.fwb_admin_password
    fwb_s3_bucket          = var.fwb_s3_bucket
    fwb_aws_region         = var.aws_region
  }
}
*/
data "aws_ami" "fortiweb_byol" {
  most_recent = true

  filter {
    name                         = "name"
    values                       = ["FortiWeb-AWS-${var.fortiweb_os_version}_BYOL_Release-*"]
  }

  filter {
    name                         = "virtualization-type"
    values                       = ["hvm"]
  }

  owners                         = ["679593333241"] # Canonical
}
/*

data "aws_ami" "fortiweb_paygo" {
  most_recent = true

  filter {
    name                         = "name"
    values                       = ["FortiWeb-AWS-${var.fortiweb_os_version}_OnDemand_Release-*"]
  }

  filter {
    name                         = "virtualization-type"
    values                       = ["hvm"]
  }

  owners                         = ["679593333241"] # Canonical
}
*/

module "iam_profile" {
  source = "../../modules/ec2_instance_iam_role"

  aws_region                  = var.aws_region
  customer_prefix             = var.customer_prefix
  environment                 = var.environment
}

#
# Security VPC, IGW, Subnets, Route Tables, Route Table Associations, VPC Endpoint
#
module "base-vpc" {
  source                          = "../base_vpc_dual_az"
  aws_region                      = var.aws_region
  customer_prefix                 = var.customer_prefix
  environment                     = var.environment
  vpc_name                        = var.vpc_name_security
  availability_zone1              = var.availability_zone_1
  availability_zone2              = var.availability_zone_2
  vpc_cidr                        = var.vpc_cidr_security
  public1_subnet_cidr             = var.public_subnet_cidr1
  public2_subnet_cidr             = var.public_subnet_cidr2
  private1_subnet_cidr            = var.private_subnet_cidr_1
  private2_subnet_cidr            = var.private_subnet_cidr_2
  public1_description             = var.public1_description
  public2_description             = var.public2_description
  private1_description            = var.private1_description
  private2_description            = var.private2_description
}


#
# This is an "allow all" security group, but a place holder for a more strict SG
#
module "allow_public_subnets" {
  source = "../../modules/security_group"
  aws_region              = var.aws_region
  vpc_id                  = module.base-vpc.vpc_id
  name                    = "${var.fortiweb_sg_name} Allow Public Subnets"
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

resource aws_security_group "fortiweb_sg" {
  name = "allow_public_subnets"
  description = "Allow all traffic from public Subnets"
  vpc_id = module.base-vpc.vpc_id
  ingress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "allow_public_subnets"
  }
}

module "fortiweb_1" {
  source                      = "../../modules/ec2_instance"

  aws_region                  = var.aws_region
  availability_zone           = var.availability_zone_1
  customer_prefix             = "${var.customer_prefix}-fortiweb"
  environment                 = var.environment
  instance_name               = var.fortiweb_1_instance_name
  instance_type               = var.fortiweb_instance_type
  public_subnet_id            = module.base-vpc.public1_subnet_id
  public_ip_address           = var.public1_ip_address
  aws_ami                     = data.aws_ami.fortiweb_byol.id
  enable_public_ips           = var.enable_public_ips_1
  keypair                     = var.keypair
  security_group_public_id    = aws_security_group.fortiweb_sg.id
  iam_instance_profile_id     = module.iam_profile.id
  userdata_rendered           = data.template_file.fwb_userdata_byol_1.rendered
}


module "fortiweb_2" {
  source                      = "../../modules/ec2_instance"

  aws_region                  = var.aws_region
  availability_zone           = var.availability_zone_2
  customer_prefix             = "${var.customer_prefix}-fortiweb"
  environment                 = var.environment
  instance_name               = var.fortiweb_2_instance_name
  instance_type               = var.fortiweb_instance_type
  public_subnet_id            = module.base-vpc.public2_subnet_id
  public_ip_address           = var.public2_ip_address
  aws_ami                     = data.aws_ami.fortiweb_byol.id
  enable_public_ips           = var.enable_public_ips_2
  keypair                     = var.keypair
  security_group_public_id    = aws_security_group.fortiweb_sg.id
  iam_instance_profile_id     = module.iam_profile.id
  userdata_rendered           = data.template_file.fwb_userdata_byol_1.rendered
}

