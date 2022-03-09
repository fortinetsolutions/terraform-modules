provider "google" {
  version     = "3.49.0"
  credentials = file(var.credentials_file_path)
  project     = var.project
  region      = var.region
  zone        = var.zone
}

module "random" {
  source = "../../modules/random-generator"
}

module "vpc" {
  source = "../../modules/vpc"
  # Pass Variables
  name = var.name
  vpcs = var.vpcs
  # Values fetched from the Modules
  random_string = module.random.random_string
}

module "subnet" {
  source = "../../modules/subnet"

  # Pass Variables
  name         = var.name
  region       = var.region
  subnets      = var.subnets
  subnet_cidrs = var.subnet_cidrs
  private_ip_google_access = null
  # Values fetched from the Modules
  random_string = module.random.random_string
  vpcs          = module.vpc.vpc_networks
}

module "firewall" {
  source = "../../modules/firewall"

  # Values fetched from the Modules
  random_string = module.random.random_string
  vpcs          = module.vpc.vpc_networks
}

module "static-ip" {
  source = "../../modules/static-ip"

  # Pass Variables
  name = var.name
  # Values fetched from the Modules
  random_string = module.random.random_string
}

module "instances" {
  source = "../../modules/fortianalyzer"

  # Pass Variables
  name            = var.name
  service_account = var.service_account
  zone            = var.zone
  machine         = var.machine
  image           = var.image
  # license_file    = var.license_file
  # Values fetched from the Modules
  random_string         = module.random.random_string
  public_vpc_network    = module.vpc.vpc_networks[0]
  public_subnet         = module.subnet.subnets[0]
  static_ip             = module.static-ip.static_ip
  public_subnet_gateway = module.subnet.public_subnet_gateway_address
}
