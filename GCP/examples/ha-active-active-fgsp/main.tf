provider "google" {
  version     = "3.49.0"
  credentials = file(var.credentials_file_path)
  project     = var.project
  region      = var.region
  zone        = var.zone
}

provider "google-beta" {
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

### Cloud Nat ###
# Allows for egress traffic on Private/Protected Subnet
module "cloud_router" {
  source = "../../modules/cloud_router"

  # Pass Variables
  name   = var.name
  region = var.region
  # Values fetched from the Modules
  random_string = module.random.random_string
  vpc_network   = module.vpc.vpc_networks[0]
}

module "cloud_nat" {
  source = "../../modules/cloud_nat"

  # Pass Variables
  name   = var.name
  region = var.region
  # Values fetched from the Modules
  random_string = module.random.random_string
  cloud_router  = module.cloud_router.name
}
### End Cloud Nat ###

### Instance Template ###
resource "google_compute_instance_template" "fgt-template" {
  name        = "${var.name}-fgttemplate-${module.random.random_string}"
  description = "Fortigate Instance Template"

  instance_description = "FortiGate Instance Template"
  machine_type         = var.machine
  can_ip_forward       = true

  scheduling {
    automatic_restart   = true
    on_host_maintenance = "MIGRATE"
  }

  # Create a new boot disk from an image
  disk {
    source_image = var.image
    auto_delete  = true
    boot         = true
  }
  # Logging Disk
  disk {
    auto_delete  = true
    boot         = false
    disk_size_gb = 30
  }
  # Public Network
  network_interface {
    network    = module.vpc.vpc_networks[0]
    subnetwork = module.subnet.subnets[0]
  }

  # Private Network
  network_interface {
    network    = module.vpc.vpc_networks[1]
    subnetwork = module.subnet.subnets[1]
  }
  # FGSP  Network
  network_interface {
    network    = module.vpc.vpc_networks[2]
    subnetwork = module.subnet.subnets[2]
  }

  # Metadata to bootstrap FGT
  metadata = {
    user-data = data.template_file.setup-fgt-instance.rendered
  }

  # Email will be the service account
  service_account {
    email  = var.service_account
    scopes = ["cloud-platform"]
  }
}

### Managed Instance Group ###
# Health Check
resource "google_compute_health_check" "autohealing" {
  name                = "${var.name}-mighealth-${module.random.random_string}"
  check_interval_sec  = var.autohealing_check_interval_sec
  timeout_sec         = var.autohealing_timeout_sec
  healthy_threshold   = var.autohealing_healthy_threshold
  unhealthy_threshold = var.autohealing_unhealthy_threshold

  tcp_health_check {
    port = var.autohealing_tcp_health_check
  }
}

# Regional Instance Group Manager
resource "google_compute_region_instance_group_manager" "mig" {
  name                      = "${var.name}-fgtmig-${module.random.random_string}"
  base_instance_name        = "${var.name}-fortigate--${module.random.random_string}"
  region                    = var.region
  distribution_policy_zones = data.google_compute_zones.get_zones.names

  target_pools = [google_compute_target_pool.default.self_link]
  target_size  = var.target_size

  auto_healing_policies {
    health_check      = google_compute_health_check.autohealing.self_link
    initial_delay_sec = var.initial_delay_sec
  }

  version {
    name              = "fgt"
    instance_template = google_compute_instance_template.fgt-template.self_link
  }
}
### End Managed Instance Group ###

### External Load Balancer ###
module "static-ip-elb" {
  source = "../../modules/static-ip"

  # Pass Variables
  name = "${var.name}-static-ip-elb"
  # Values fetched from the Modules
  random_string = module.random.random_string
}

resource "google_compute_forwarding_rule" "elb-tcp" {
  name       = "${var.name}-elb-tcp-rule-${module.random.random_string}"
  region     = var.region
  ip_address = module.static-ip-elb.static_ip
  port_range = "1-65535"

  target = google_compute_target_pool.default.self_link
}

# Health Check
resource "google_compute_http_health_check" "ext_lb_health_check" {
  name                = "${var.name}-elbhealth-${module.random.random_string}"
  check_interval_sec  = var.elb_check_interval_sec
  timeout_sec         = var.elb_timeout_sec
  unhealthy_threshold = var.elb_unhealthy_threshold
  port                = var.elb_port
}

# Target Pool
resource "google_compute_target_pool" "default" {
  name = "${var.name}-elb-pool-${module.random.random_string}"

  health_checks = [
    google_compute_http_health_check.ext_lb_health_check.name
  ]
}
### End External Load Balancer ###

### Internal Load Balancer ###
resource "google_compute_forwarding_rule" "internal_load_balancer" {
  provider   = google-beta
  name       = "${var.name}-internal-lb-${module.random.random_string}"
  region     = var.region
  ip_address = var.ilb_vip

  load_balancing_scheme = "INTERNAL"
  backend_service       = google_compute_region_backend_service.internal_load_balancer_backend.self_link
  all_ports             = true
  network               = module.vpc.vpc_networks[1]
  subnetwork            = module.subnet.subnets[1]
}

resource "google_compute_region_backend_service" "internal_load_balancer_backend" {
  provider = google-beta
  name     = "${var.name}-fgt-outbound-backend-${module.random.random_string}"
  region   = var.region
  network  = module.vpc.vpc_networks[1]

  backend {
    group       = google_compute_region_instance_group_manager.mig.instance_group
    description = "ILB"
  }

  health_checks = [google_compute_region_health_check.int_lb_health_check.self_link]
}

# Regional Health Check
resource "google_compute_region_health_check" "int_lb_health_check" {
  name               = "${var.name}-fgt-lbhealth-${module.random.random_string}"
  region             = var.region
  check_interval_sec = var.int_check_interval_sec
  timeout_sec        = var.int_timeout_sec
  tcp_health_check {
    port = var.int_port
  }
}
### End Internal Load Balancer ###

#### Routes for ILB
resource "google_compute_route" "outbound_lb_route" {
  name         = "${var.name}-outbound-route-${module.random.random_string}"
  dest_range   = "0.0.0.0/0"
  network      = module.vpc.vpc_networks[1]
  next_hop_ilb = google_compute_forwarding_rule.internal_load_balancer.id
  priority     = 100
}
#### Routes for ILB

### Bastion Host ###
module "static-ip" {
  source = "../../modules/static-ip"

  # Pass Variables
  name = var.name
  # Values fetched from the Modules
  random_string = module.random.random_string
}

module "bastionhost_windows" {
  source = "../../modules/bastionhost_windows"

  # Pass Variables
  name            = var.name
  image           = var.bastionhost_image
  machine         = var.bastionhost_machine
  service_account = var.service_account
  zone            = var.zone
  # Values fetched from the Modules
  random_string      = module.random.random_string
  public_vpc_network = module.vpc.vpc_networks[0]
  public_subnet      = module.subnet.subnets[0]
  static_ip          = module.static-ip.static_ip
}
### End Bastion Host ###s
