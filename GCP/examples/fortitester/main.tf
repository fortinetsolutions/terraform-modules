terraform {
  required_version = ">=0.12.0"
  required_providers {
    google      = ">=3.49.0"
    google-beta = ">=3.49.0"
  }
}
provider "google" {
  credentials = file(var.credentials_file_path)
  project     = var.project
  region      = var.region
  zone        = var.zone
}
provider "google-beta" {
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
  source = "../../modules/fortitester"

  # Pass Variables
  name            = var.name
  service_account = var.service_account
  zone            = var.zone
  machine         = var.machine
  image           = var.image
  # Values fetched from the Modules
  random_string     = module.random.random_string
  mgmt_vpc_network  = module.vpc.vpc_networks[0]
  mgmt_subnet       = module.subnet.subnets[0]
  port1_vpc_network = module.vpc.vpc_networks[1]
  port1_subnet      = module.subnet.subnets[1]
  port2_vpc_network = module.vpc.vpc_networks[2]
  port2_subnet      = module.subnet.subnets[2]
  static_ip         = module.static-ip.static_ip
}
