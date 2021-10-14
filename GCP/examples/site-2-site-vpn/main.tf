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
  routing_mode  = var.vpc_routing_mode

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

# External VPN Gateway
resource "google_compute_external_vpn_gateway" "external_gateway" {
  name            = "${var.name}-external-gateway-${module.random.random_string}"
  redundancy_type = "SINGLE_IP_INTERNALLY_REDUNDANT"
  description     = "An externally managed VPN gateway"
  interface {
    id         = 0
    ip_address = var.fgt_ip
  }
}

# HA VPN Gateway
resource "google_compute_ha_vpn_gateway" "ha_gateway" {
  name    = "${var.name}-vpn-gateway-${module.random.random_string}"
  network = module.vpc.vpc_networks[0]
  region  = var.region
}

### Cloud Router ###
module "cloud_router" {
  source = "../../modules/cloud_router"

  # Pass Variables
  name   = var.name
  region = var.region
  # Values fetched from the Modules
  random_string = module.random.random_string
  vpc_network   = module.vpc.vpc_networks[0]
  bgp = {
    asn = var.cr_asn
  }
}

# VPN Tunnel1
resource "google_compute_vpn_tunnel" "tunnel1" {
  name                            = "${var.name}-tunnel1-${module.random.random_string}"
  region                          = var.region
  vpn_gateway                     = google_compute_ha_vpn_gateway.ha_gateway.id
  peer_external_gateway           = google_compute_external_vpn_gateway.external_gateway.id
  peer_external_gateway_interface = 0
  shared_secret                   = var.shared_secret
  router                          = module.cloud_router.id
  vpn_gateway_interface           = 0
}

# VPN Tunnel2
resource "google_compute_vpn_tunnel" "tunnel2" {
  name                            = "${var.name}-tunnel2-${module.random.random_string}"
  region                          = var.region
  vpn_gateway                     = google_compute_ha_vpn_gateway.ha_gateway.id
  peer_external_gateway           = google_compute_external_vpn_gateway.external_gateway.id
  peer_external_gateway_interface = 0
  shared_secret                   = var.shared_secret
  router                          = module.cloud_router.id
  vpn_gateway_interface           = 1
}

resource "google_compute_router_interface" "router1_interface1" {
  name       = "${var.name}-cr-interface1-${module.random.random_string}"
  router     = module.cloud_router.name
  region     = var.region
  ip_range   = var.cr_interface_ip_range[0]
  vpn_tunnel = google_compute_vpn_tunnel.tunnel1.name
}

resource "google_compute_router_peer" "router1_peer1" {
  name                      = "${var.name}-cr-peer1-${module.random.random_string}"
  router                    = module.cloud_router.name
  region                    = var.region
  peer_ip_address           = var.cr_peer_ip_address[0]
  peer_asn                  = var.cr_peer_asn
  advertised_route_priority = var.cr_advertised_route_priority
  interface                 = google_compute_router_interface.router1_interface1.name
}

resource "google_compute_router_interface" "router1_interface2" {
  name       = "${var.name}-cr-interface2-${module.random.random_string}"
  router     = module.cloud_router.name
  region     = var.region
  ip_range   = var.cr_interface_ip_range[1]
  vpn_tunnel = google_compute_vpn_tunnel.tunnel2.name
}

resource "google_compute_router_peer" "router1_peer2" {
  name                      = "${var.name}-cr-peer2-${module.random.random_string}"
  router                    = module.cloud_router.name
  region                    = var.region
  peer_ip_address           = var.cr_peer_ip_address[1]
  peer_asn                  = var.cr_peer_asn
  advertised_route_priority = var.cr_advertised_route_priority
  interface                 = google_compute_router_interface.router1_interface2.name
}
