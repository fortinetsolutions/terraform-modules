
provider "aws" {
  region     = var.aws_region
}


module "vpc" {
  source = "../../modules/vpc"

  aws_region                 = var.aws_region
  environment                = var.environment
  customer_prefix            = var.customer_prefix
  vpc_name                   = var.vpc_name
  vpc_cidr                   = var.vpc_cidr

}

resource "aws_default_route_table" "route_public" {
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

module "public1-subnet" {
  source = "../../modules/subnet"

  aws_region                 = var.aws_region
  environment                = var.environment
  customer_prefix            = var.customer_prefix
  vpc_id                     = module.vpc.vpc_id
  availability_zone          = var.availability_zone1
  subnet_cidr                = var.public1_subnet_cidr
  subnet_description         = var.public1_description
  public_route               = 1
  public_route_table_id      = module.public_route_table.id
}

module "private1-subnet" {
  source = "../../modules/subnet"

  aws_region                 = var.aws_region
  environment                = var.environment
  customer_prefix            = var.customer_prefix
  vpc_id                     = module.vpc.vpc_id
  availability_zone          = var.availability_zone1
  subnet_cidr                = var.private1_subnet_cidr
  subnet_description         = var.private1_description
}

module "public2-subnet" {
  source = "../../modules/subnet"

  aws_region                 = var.aws_region
  environment                = var.environment
  customer_prefix            = var.customer_prefix
  vpc_id                     = module.vpc.vpc_id
  availability_zone          = var.availability_zone2
  subnet_cidr                = var.public2_subnet_cidr
  subnet_description         = var.public2_description
  public_route               = 1
  public_route_table_id      = module.public_route_table.id
}

module "private2-subnet" {
  source = "../../modules/subnet"

  aws_region                 = var.aws_region
  environment                = var.environment
  customer_prefix            = var.customer_prefix
  vpc_id                     = module.vpc.vpc_id
  availability_zone          = var.availability_zone2
  subnet_cidr                = var.private2_subnet_cidr
  subnet_description         = var.private2_description
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

module "private1_route_table" {
  source                     = "../../modules/route_table"

  aws_region                 = var.aws_region
  customer_prefix            = var.customer_prefix
  environment                = var.environment
  vpc_id                     = module.vpc.vpc_id
  route_description          = "Private 1 Route Table"
}


module "private1_route_table_association" {
  source                     = "../../modules/route_table_association"

  aws_region                 = var.aws_region
  customer_prefix            = var.customer_prefix
  environment                = var.environment
  subnet_ids                 = module.private1-subnet.id
  route_table_id             = module.private1_route_table.id
}

module "private2_route_table" {
  source                     = "../../modules/route_table"
  aws_region                 = var.aws_region
  customer_prefix            = var.customer_prefix
  environment                = var.environment
  vpc_id                     = module.vpc.vpc_id
  route_description          = "Private 2 Route Table"
}

module "private2_route_table_association" {
  source                     = "../../modules/route_table_association"

  aws_region                 = var.aws_region
  customer_prefix            = var.customer_prefix
  environment                = var.environment
  subnet_ids                 = module.private2-subnet.id
  route_table_id             = module.private2_route_table.id
}
