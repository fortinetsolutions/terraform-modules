
provider "aws" {
  region     = var.aws_region
}

data "aws_ec2_transit_gateway" "tgw" {
  filter {
    name   = "tag:Name"
    values = ["lse1-poc-tgw"]
  }
  filter {
    name   = "state"
    values = ["available"]
  }
}
data "aws_ec2_transit_gateway_vpc_attachment" "tgw-sec-attachment" {
  filter {
    name   = "tag:Name"
    values = ["lse1-poc-tgw-SecurityVpcTransitGateWayAttachment"]
  }
  filter {
    name   = "state"
    values = ["available"]
  }
}
data "aws_ec2_transit_gateway_route_table" "tgw-sec-route_table" {
  filter {
    name   = "tag:Name"
    values = ["lse1-poc-tgw-TransitGatewaySecurityRouteTable"]
  }
}

#
# East VPC Transit Gateway Attachment, Route Table and Routes
#
module "vpc-transit-gateway-attachment-east" {
  source                                          = "../../modules/tgw-attachment"
  aws_region                                      = var.aws_region
  customer_prefix                                 = var.customer_prefix
  environment                                     = var.environment
  vpc_name                                        = var.vpc_name_east
  transit_gateway_id                              = data.aws_ec2_transit_gateway.tgw.id
  subnet_ids                                      = [ module.subnet-east-1.id ]
  transit_gateway_default_route_table_propogation = "false"
  vpc_id                                          = module.vpc-east.vpc_id
}

resource "aws_ec2_transit_gateway_route_table" "east" {
  transit_gateway_id = data.aws_ec2_transit_gateway.tgw.id
    tags = {
      Name = "${var.customer_prefix}-${var.environment}-East VPC TGW Route Table"
  }
}
resource "aws_ec2_transit_gateway_route_table_association" "east" {
  transit_gateway_attachment_id  = module.vpc-transit-gateway-attachment-east.tgw_attachment_id
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.east.id
}
resource "aws_ec2_transit_gateway_route" "tgw_route_east_default" {
  destination_cidr_block         = "0.0.0.0/0"
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.east.id
  transit_gateway_attachment_id  = data.aws_ec2_transit_gateway_vpc_attachment.tgw-sec-attachment.id
}

resource "aws_ec2_transit_gateway_route" "tgw_route_east_security" {
  destination_cidr_block         = var.vpc_cidr_east
  transit_gateway_route_table_id = data.aws_ec2_transit_gateway_route_table.tgw-sec-route_table.id
  transit_gateway_attachment_id  = module.vpc-transit-gateway-attachment-east.tgw_attachment_id
}

#
# East VPC
#
module "igw" {
  source = "../../modules/igw"

  aws_region                 = var.aws_region
  environment                = var.environment
  customer_prefix            = var.customer_prefix
  vpc_id                     = module.vpc-east.vpc_id
}

module "vpc-east" {
  source = "../../modules/vpc"

  aws_region                 = var.aws_region
  environment                = var.environment
  vpc_name                   = var.vpc_name_east
  customer_prefix            = var.customer_prefix
  vpc_cidr                   = var.vpc_cidr_east
}

module "subnet-east-1" {
  source = "../../modules/subnet"

  aws_region                 = var.aws_region
  environment                = var.environment
  customer_prefix            = var.customer_prefix
  vpc_id                     = module.vpc-east.vpc_id
  availability_zone          = var.availability_zone_1
  subnet_cidr                = var.vpc_cidr_east-1
  subnet_description         = "east 1"
}

module "subnet-east-2" {
  source = "../../modules/subnet"

  aws_region                 = var.aws_region
  environment                = var.environment
  customer_prefix            = var.customer_prefix
  vpc_id                     = module.vpc-east.vpc_id
  availability_zone          = var.availability_zone_1
  subnet_cidr                = var.vpc_cidr_east-2
  subnet_description         = "east 2"
}

module "subnet-east-3" {
  source = "../../modules/subnet"

  aws_region                 = var.aws_region
  environment                = var.environment
  customer_prefix            = var.customer_prefix
  vpc_id                     = module.vpc-east.vpc_id
  availability_zone          = var.availability_zone_1
  subnet_cidr                = var.vpc_cidr_east-3
  subnet_description         = "east 3"
}

#
# Default route table that is created with the east VPC. We just need to add a default route
# that points to the TGW Attachment
#
resource "aws_default_route_table" "route_east" {
  default_route_table_id = module.vpc-east.vpc_main_route_table_id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = module.igw.igw_id
  }
  tags = {
    Name = "default table for vpc east"
  }
}

resource "aws_route_table" "route_east_data" {
  vpc_id = module.vpc-east.vpc_id
  tags = {
    Name = "route table for east testing subnets"
  }
}

resource "aws_route" "gateway" {
  route_table_id         = aws_route_table.route_east_data.id
  destination_cidr_block = "0.0.0.0/0"
  transit_gateway_id = data.aws_ec2_transit_gateway.tgw.id
}

module "rta-east-1" {
  source = "../../modules/route_table_association"

  aws_region                 = var.aws_region
  environment                = var.environment
  customer_prefix            = "${var.customer_prefix}-east"
  subnet_ids                 = module.subnet-east-1.id
  route_table_id             = module.vpc-east.vpc_main_route_table_id
}

module "rta-east-2" {
  source = "../../modules/route_table_association"

  aws_region                 = var.aws_region
  environment                = var.environment
  customer_prefix            = "${var.customer_prefix}-east"
  subnet_ids                 = module.subnet-east-2.id
  route_table_id             = aws_route_table.route_east_data.id
}

module "rta-east-3" {
  source = "../../modules/route_table_association"

  aws_region                 = var.aws_region
  environment                = var.environment
  customer_prefix            = "${var.customer_prefix}-east"
  subnet_ids                 = module.subnet-east-3.id
  route_table_id             = aws_route_table.route_east_data.id
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

#
# EC2 Endpoint Resources
#

#
# Security Groups are VPC specific, so an "ALLOW ALL" for each VPC
#
module "ec2-east-sg" {
  source = "../../modules/security_group"

  aws_region           = var.aws_region
  vpc_id               = module.vpc-east.vpc_id
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

resource "aws_instance" "ec2" {
  ami                         = data.aws_ami.ubuntu.id
  instance_type               = var.linux_instance_type
  availability_zone           = var.availability_zone_1
  subnet_id                   = module.subnet-east-1.id
  key_name                    = var.keypair
  user_data                   = data.template_file.web_userdata.rendered
  iam_instance_profile        = module.linux_iam_profile.id
  associate_public_ip_address = true
  private_ip                  = "192.168.0.6"
  security_groups             = [ module.ec2-east-sg.id ]
  tags = {
    Name            = "${var.customer_prefix}-${var.environment}-east-linux-instance"
    Environment     = var.environment
  }
}

resource "aws_network_interface" "east_eni" {
  subnet_id                   = module.subnet-east-2.id
  private_ips                 = [ "192.168.0.38" ]
  security_groups             = [ module.ec2-east-sg.id ]
  source_dest_check           = false
  attachment {
    instance                  = aws_instance.ec2.id
    device_index              = 2
  }
  tags = {
    Name = "${var.customer_prefix}-${var.environment}-east-data-eni"
  }
}
