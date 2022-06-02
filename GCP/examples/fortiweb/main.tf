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
  region      = var.region
  # Values fetched from the Modules
  random_string = module.random.random_string
}

# FortiWeb
module "instances" {
  source = "../../modules/fortiweb"

  # Pass Variables
  name            = var.name
  service_account = var.service_account
  zone            = var.zone
  machine         = var.machine
  image           = var.image
  license_file    = var.license_file
  # Values fetched from the Modules
  random_string       = module.random.random_string
  public_vpc_network  = module.vpc.vpc_networks[0]
  private_vpc_network = module.vpc.vpc_networks[1]
  public_subnet       = module.subnet.subnets[0]
  private_subnet      = module.subnet.subnets[1]
  static_ip           = module.static-ip.static_ip
}



# module "instances_nginx" {
#   source = "../../modules/nginx_instance"

#   # Pass Variables
#   name    = var.name
#   zone    = var.zone
#   machine = var.machine
#   image   = var.ubuntu_image
#   # Values fetched from the Modules
#   random_string      = module.random.random_string
#   public_vpc_network = module.vpc.vpc_networks[1]
#   public_subnet      = module.subnet.subnets[1]
# }
