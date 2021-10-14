
provider "aws" {
  region     = var.aws_region
}


module "vpc" {
  source = "../../modules/vpc"

  aws_region                 = var.aws_region
  environment                = var.environment
  customer_prefix            = var.customer_prefix
  vpc_cidr                   = var.vpc_cidr
  vpc_name                   = var.vpc_name

}

resource "aws_default_route_table" "route_security" {
  default_route_table_id = module.vpc.vpc_main_route_table_id
  tags = {
    Name = "default route table for vpc (unused)"
  }
}

module "igw" {
  source = "../../modules/igw"

  aws_region                 = var.aws_region
  environment                = var.environment
  customer_prefix            = var.customer_prefix
  vpc_id                     = module.vpc.vpc_id
}

module "public-subnet" {
  source = "../../modules/subnet"

  aws_region                 = var.aws_region
  environment                = var.environment
  customer_prefix            = var.customer_prefix
  vpc_id                     = module.vpc.vpc_id
  availability_zone          = var.availability_zone
  subnet_cidr                = var.public_subnet_cidr
  subnet_description         = var.public_description
  public_route               = 1
  public_route_table_id      = module.public_route_table.id
}

module "public_route_table" {
  source                     = "../../modules/route_table"

  aws_region                 = var.aws_region
  customer_prefix            = var.customer_prefix
  environment                = var.environment
  vpc_id                     = module.vpc.vpc_id
  gateway_route              = 1
  igw_id                     = module.igw.igw_id
  route_description          = "Public Route Table"
}


module "private-subnet" {
  source = "../../modules/subnet"

  aws_region                 = var.aws_region
  environment                = var.environment
  customer_prefix            = var.customer_prefix
  vpc_id                     = module.vpc.vpc_id
  availability_zone          = var.availability_zone
  subnet_cidr                = var.private_subnet_cidr
  subnet_description         = var.private_description

}

module "private_route_table" {
  source                     = "../../modules/route_table"

  aws_region                 = var.aws_region
  customer_prefix            = var.customer_prefix
  environment                = var.environment
  vpc_id                     = module.vpc.vpc_id
  route_description          = "Private Route Table"
}

module "private_route_table_association" {
  source                     = "../../modules/route_table_association"

  aws_region                 = var.aws_region
  customer_prefix            = var.customer_prefix
  environment                = var.environment
  subnet_ids                 = module.private-subnet.id
  route_table_id             = module.private_route_table.id
}
