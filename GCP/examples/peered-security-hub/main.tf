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
  name                     = var.name
  region                   = var.region
  subnets                  = var.subnets
  subnet_cidrs             = var.subnet_cidrs
  private_ip_google_access = var.subnet_private_ip_google_access
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

module "route" {
  source = "../../modules/route"

  # Pass Variables
  name        = var.name
  next_hop_ip = var.next_hop_ip
  # Values fetched from the Modules
  random_string = module.random.random_string
  vpc_network   = module.vpc.vpc_networks[1]
  # Route depends on the Private_Subnet
  route_depends_on = module.subnet.subnets[1]
}

module "fgt-route-direct" {
  source = "../../modules/route"

  # Pass Variables
  name             = "${var.name}-fgt-route-direct"
  next_hop_gateway = var.next_hop_gateway
  priority         = 10
  tags             = var.tags
  # Values fetched from the Modules
  random_string = module.random.random_string
  vpc_network   = module.vpc.vpc_networks[0]
  # Route depends on the Private_Subnet
  route_depends_on = module.subnet.subnets[0]
}

module "static-ip" {
  source = "../../modules/static-ip"

  # Pass Variables
  name = var.name
  # Values fetched from the Modules
  random_string = module.random.random_string
}

module "instances" {
  source = "../../modules/peered_security_spokes"

  # Pass Variables
  name               = var.name
  service_account    = var.service_account
  zone               = var.zone
  machine            = var.machine
  image              = var.image
  license_file       = var.license_file
  license_file_2     = var.license_file_2
  active_port1_ip    = var.active_port1_ip
  active_port1_mask  = var.active_port1_mask
  active_port2_ip    = var.active_port2_ip
  active_port2_mask  = var.active_port2_mask
  active_port3_ip    = var.active_port3_ip
  active_port3_mask  = var.active_port3_mask
  active_port4_ip    = var.active_port4_ip
  active_port4_mask  = var.active_port4_mask
  passive_port1_ip   = var.passive_port1_ip
  passive_port1_mask = var.passive_port1_mask
  passive_port2_ip   = var.passive_port2_ip
  passive_port2_mask = var.passive_port2_mask
  passive_port3_ip   = var.passive_port3_ip
  passive_port3_mask = var.passive_port3_mask
  passive_port4_ip   = var.passive_port4_ip
  passive_port4_mask = var.passive_port4_mask
  mgmt_gateway       = var.mgmt_gateway
  mgmt_mask          = var.mgmt_mask
  tags               = var.tags
  # Values fetched from the Modules
  random_string          = module.random.random_string
  public_vpc_network     = module.vpc.vpc_networks[0]
  private_vpc_network    = module.vpc.vpc_networks[1]
  sync_vpc_network       = module.vpc.vpc_networks[2]
  mgmt_vpc_network       = module.vpc.vpc_networks[3]
  public_subnet          = module.subnet.subnets[0]
  private_subnet         = module.subnet.subnets[1]
  sync_subnet            = module.subnet.subnets[2]
  mgmt_subnet            = module.subnet.subnets[3]
  static_ip              = module.static-ip.static_ip
  public_subnet_gateway  = module.subnet.subnet_gateway_address[0]
  private_subnet_gateway = module.subnet.subnet_gateway_address[1]
  frontend_cidr          = var.subnet_cidrs[4]
}

###############
# VPC Peering #
###############
module "peering" {
  source = "../../modules/vpc_peering"
  peerings = [{
    name                 = "peering1"
    export_custom_routes = true
    import_custom_routes = false
    network              = module.vpc.vpc_networks_selflink[1],
    peer_network         = module.vpc.vpc_networks_selflink[4],
    }, {
    name                 = "peering2"
    export_custom_routes = false
    import_custom_routes = true
    network              = module.vpc.vpc_networks_selflink[4],
    peer_network         = module.vpc.vpc_networks_selflink[1],
  }]
}

##############
# Web Server #
##############
module "instances_nginx" {
  source = "../../modules/nginx_instance"

  # Pass Variables
  name    = var.name
  zone    = var.zone
  machine = var.machine
  image   = var.ubuntu_image
  # Values fetched from the Modules
  random_string      = module.random.random_string
  public_vpc_network = module.vpc.vpc_networks[4]
  public_subnet      = module.subnet.subnets[4]
}
