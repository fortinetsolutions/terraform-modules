
provider "aws" {
  region     = var.aws_region
}


data "aws_ami" "fortigate_byol" {
  most_recent = true

  filter {
    name                         = "name"
    values                       = [
      var.fortigate_ami_string]
  }

  filter {
    name                         = "virtualization-type"
    values                       = ["hvm"]
  }

  owners                         = ["679593333241"] # Canonical
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

  access_key                 = var.access_key
  secret_key                 = var.secret_key
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

module "fortigate" {
  source                      = "../../modules/fortigate_byol"

  access_key                  = var.access_key
  secret_key                  = var.secret_key
  aws_region                  = var.aws_region
  availability_zone           = var.availability_zone_1
  customer_prefix             = var.customer_prefix
  environment                 = var.environment
  public_subnet_id            = module.base-vpc.public_subnet_id
  public_ip_address           = var.public1_ip_address
  private_subnet_id           = module.base-vpc.private_subnet_id
  private_ip_address          = var.private1_ip_address
  aws_fgtbyol_ami             = data.aws_ami.fortigate_byol.id
  keypair                     = var.keypair
  fgt_instance_type           = var.fortigate_instance_type
  fortigate_instance_name     = var.fortigate_instance_name
  enable_public_ips           = var.public_ip
  security_group_private_id   = aws_security_group.allow_private_subnets.id
  security_group_public_id    = aws_security_group.allow_public_subnets.id
  acl                         = var.acl
  fgt_byol_license            = var.fgt_byol_license
  fgt_password_parameter_name = var.fgt_password_parameter_name
}

#
# Point the private route table default route to the Fortigate Private ENI
#
resource "aws_route" "private" {
  route_table_id         = module.base-vpc.private_route_table_id
  destination_cidr_block = "0.0.0.0/0"
  network_interface_id   = module.fortigate.network_private_interface_id
}


module "private_route_table_association" {
  source                     = "../../modules/route_table_association"

  access_key                 = var.access_key
  secret_key                 = var.secret_key
  aws_region                 = var.aws_region
  customer_prefix            = var.customer_prefix
  environment                = var.environment
  subnet_ids                 = module.base-vpc.private_subnet_id
  route_table_id             = module.base-vpc.private_route_table_id
}