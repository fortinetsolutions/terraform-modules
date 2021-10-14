
provider "aws" {
  region     = var.aws_region
}

data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-bionic-18.04-amd64-server-20200729"]
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
  vpc_id               = module.base-vpc.vpc_id
  name                 = var.ec2_sg_name
  ingress_to_port         = 0
  ingress_from_port       = 0
  ingress_protocol        = "-1"
  ingress_cidr_for_access = "0.0.0.0/0"
  egress_to_port          = 0
  egress_from_port        = 0
  egress_protocol         = "-1"
  egress_cidr_for_access = "0.0.0.0/0"
  customer_prefix      = var.customer_prefix
  environment          = var.environment
}


#
# IAM Profile for linux instance
#
module "linux_iam_profile" {
  source = "../../modules/ec2_instance_iam_role"

  aws_region                  = var.aws_region
  customer_prefix             = var.customer_prefix
  environment                 = var.environment
}


#
# Optional Linux Instances from here down
#
# Linux Instance that are added on to the East and West VPCs for testing EAST->West Traffic
#
# Endpoint AMI to use for Linux Instances. Just added this on the end, since traffic generating linux instances
# would not make it to a production template.
#

data "template_file" "web_userdata" {
  template = file("./config_templates/web-userdata.tpl")
}

#
# East Linux Instance for Generating East->West Traffic
#
module "aws_linux_instance" {
  source                      = "../../modules/ec2_instance"

  aws_region                  = var.aws_region
  customer_prefix             = var.customer_prefix
  environment                 = var.environment
  enable_public_ips           = true
  availability_zone           = var.availability_zone_1
  public_subnet_id            = module.base-vpc.public_subnet_id
  public_ip_address           = "10.0.0.11"
  aws_ami                     = data.aws_ami.ubuntu.id
  keypair                     = var.keypair
  instance_type               = var.linux_instance_type
  instance_name               = var.linux_instance_name
  security_group_public_id    = module.ec2-sg.id
  acl                         = var.acl
  iam_instance_profile_id     = module.linux_iam_profile.id
  userdata_rendered           = data.template_file.web_userdata.rendered
}

resource aws_security_group "allow_private_subnets" {
  name = "allow_private_subnets"
  description = "Allow all traffic from Private Subnets"
  vpc_id = module.base-vpc.vpc_id
  ingress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = [
      var.private_subnet_cidr1]
  }
  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "allow_private_subnets"
  }
}

resource aws_security_group "allow_public_subnets" {
  name = "allow_public_subnets"
  description = "Allow all traffic from public Subnets"
  vpc_id = module.base-vpc.vpc_id
  ingress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = [
      var.public_subnet_cidr1, var.cidr_for_access]
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

module "base-vpc" {
  source = "../../main_scripts/base_vpc_single_az"

  aws_region                 = var.aws_region
  environment                = var.environment
  customer_prefix            = var.customer_prefix
  availability_zone          = var.availability_zone_1
  public_subnet_cidr         = var.public_subnet_cidr1
  public_description         = var.public1_description
  private_subnet_cidr        = var.private_subnet_cidr1
  private_description        = var.private1_description
  vpc_name                   = "base"
  vpc_cidr                   = var.vpc_cidr

}

resource "aws_default_route_table" "default_route" {
  default_route_table_id = module.base-vpc.vpc_main_route_table_id
  tags = {
    Name = "default table for base vpc (unused)"
  }
}


module "private_route_table_association" {
  source                     = "../../modules/route_table_association"

  aws_region                 = var.aws_region
  customer_prefix            = var.customer_prefix
  environment                = var.environment
  subnet_ids                 = module.base-vpc.private_subnet_id
  route_table_id             = module.base-vpc.private_route_table_id
}