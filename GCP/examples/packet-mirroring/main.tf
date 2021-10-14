provider "google" {
  version     = "3.20.0"
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

### Ubuntu Instances ###s
module "ubuntu_instances" {
  source = "../../modules/ubuntu_instances"

  # Pass Variables
  name            = var.name
  image           = var.ubuntu_image
  machine         = var.ubuntu_machine
  service_account = var.service_account
  zone            = var.zone
  instance_count  = var.instance_count
  # Values fetched from the Modules
  random_string      = module.random.random_string
  public_vpc_network = module.vpc.vpc_networks[0]
  public_subnet      = module.subnet.subnets[0]
}
### End Ubuntu Instances ###s

# Compute Engine Instance
resource "google_compute_instance" "fgt_instance" {
  name           = "${var.name}-packet-mirroring-instance-${module.random.random_string}"
  machine_type   = var.fgt_machine
  zone           = var.zone
  can_ip_forward = "true"
  tags           = [var.tag]

  boot_disk {
    initialize_params {
      image = var.image
    }
  }

  # Public Network
  network_interface {
    network    = module.vpc.vpc_networks[1]
    subnetwork = module.subnet.subnets[1]
    access_config {
      # nat_ip = var.static_ip
    }
  }

  # Private Network
  network_interface {
    network    = module.vpc.vpc_networks[2]
    subnetwork = module.subnet.subnets[2]
  }

  # Peering Network
  network_interface {
    network    = module.vpc.vpc_networks[3]
    subnetwork = module.subnet.subnets[3]
  }

  # Metadata to bootstrap FGT
  metadata = {
    user-data = data.template_file.setup-fgt-instance.rendered
  }

  # Service Account scope for the GCP SDN Connector
  service_account {
    email  = var.service_account
    scopes = ["cloud-platform"]
  }
}

### UnManaged Instance Group ###
resource "google_compute_instance_group" "umig" {
  name        = "${var.name}-unmanaged-instance-group"
  description = "Pakcet Mirroring Unmanaged Instance Group"

  instances = [
    google_compute_instance.fgt_instance.self_link
  ]

  zone = var.zone
}
### UnManaged Instance Group ###

### Internal Load Balancer ###
resource "google_compute_forwarding_rule" "internal_load_balancer" {
  provider               = google-beta
  name                   = "${var.name}-internal-lb-${module.random.random_string}"
  region                 = var.region
  is_mirroring_collector = true

  load_balancing_scheme = "INTERNAL"
  backend_service       = google_compute_region_backend_service.internal_load_balancer_backend.self_link
  all_ports             = true
  network               = module.vpc.vpc_networks[3]
  subnetwork            = module.subnet.subnets[3]
}

resource "google_compute_region_backend_service" "internal_load_balancer_backend" {
  provider = google-beta
  name     = "${var.name}-internal-lb-backend-${module.random.random_string}"
  region   = var.region
  network  = module.vpc.vpc_networks[3]

  backend {
    group = google_compute_instance_group.umig.id
  }

  health_checks = [google_compute_health_check.int_lb_health_check.self_link]
}

resource "google_compute_health_check" "int_lb_health_check" {
  name               = "${var.name}-healthcheck-internal-lb-${module.random.random_string}"
  check_interval_sec = var.int_check_interval_sec
  timeout_sec        = var.int_timeout_sec
  tcp_health_check {
    port = var.int_port
  }
}
### End Internal Load Balancer ###

### VPC Peering ###
resource "google_compute_network_peering" "ubuntu_to_mirroring" {
  name         = "${var.name}-ubuntu-to-mirroring-${module.random.random_string}"
  network      = "projects/${var.project}/global/networks/${module.vpc.vpc_networks[0]}"
  peer_network = "projects/${var.project}/global/networks/${module.vpc.vpc_networks[3]}"
}

resource "google_compute_network_peering" "mirroring_to_ubuntu" {
  name         = "${var.name}-mirroring-to-ubuntu-${module.random.random_string}"
  network      = "projects/${var.project}/global/networks/${module.vpc.vpc_networks[3]}"
  peer_network = "projects/${var.project}/global/networks/${module.vpc.vpc_networks[0]}"
}
### VPC Peering ###

### Packet Mirroring ###
resource "google_compute_packet_mirroring" "packet_mirroring" {
  name        = "${var.name}-packet-mirroring-${module.random.random_string}"
  provider    = google-beta
  description = "Packet Mirroring"
  network {
    url = "projects/${var.project}/global/networks/${module.vpc.vpc_networks[0]}"
  }
  collector_ilb {
    url = google_compute_forwarding_rule.internal_load_balancer.id
  }
  mirrored_resources {
    subnetworks {
      url = module.subnet.subnets[0]
    }
  }
}
### Packet Mirroring ###
