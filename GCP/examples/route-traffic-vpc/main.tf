provider "google" {
  version     = "3.20.0"
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

# External IP
# https://www.terraform.io/docs/providers/google/r/compute_address.html
module "static_ip" {
  source = "../../modules/static-ip"

  # Pass Variables
  name = var.name
  # Values fetched from the Modules
  random_string = module.random.random_string
}

module "instances" {
  source = "../../modules/fortigate_byol_no_intf_mappings"

  # Pass Variables
  name            = var.name
  service_account = var.service_account
  zone            = var.zone
  machine         = var.machine
  image           = var.image
  license_file    = var.license_file
  # Values fetched from the Modules
  random_string         = module.random.random_string
  public_vpc_network    = module.vpc.vpc_networks[0]
  private_vpc_network   = module.vpc.vpc_networks[1]
  public_subnet         = module.subnet.subnets[0]
  private_subnet        = module.subnet.subnets[1]
  static_ip             = module.static_ip.static_ip
  nginx_internal_ip     = module.instances_nginx.nginx_ip
  public_subnet_gateway = module.subnet.public_subnet_gateway_address
}

module "instances_nginx" {
  source = "../../modules/nginx_instance"

  # Pass Variables
  name    = var.name
  zone    = var.zone
  machine = var.machine
  image   = var.ubuntu_image
  # Values fetched from the Modules
  random_string      = module.random.random_string
  public_vpc_network = module.vpc.vpc_networks[0]
  public_subnet      = module.subnet.subnets[0]
}

# Compute Target Instance
module "compute_target_instance" {
  source = "../../modules/compute_target_instance"

  # Values fetched from the Modules
  name          = var.name
  random_string = module.random.random_string
  instance_id   = module.instances.instance_id
}

# Forwarding Rules
module "compute_forwarding_rule" {
  source = "../../modules/compute_forwarding_rule"

  # Values fetched from the Modules
  name               = var.name
  random_string      = module.random.random_string
  target_instance_id = module.compute_target_instance.target_instance_id
  static_ip          = module.static_ip.static_ip
}
