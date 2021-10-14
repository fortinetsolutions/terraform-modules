provider "google" {
  version     = "3.49.0"
  credentials = file(var.credentials_file_path)
  project     = var.project
  region      = var.spoke1_region
  zone        = var.spoke1_zone
}

module "random" {
  source = "../../modules/random-generator"
}

#############
# Spoke - 1 #
#############
module "vpc_ncc" {
  source = "../../modules/vpc"
  # Pass Variables
  name = var.name
  vpcs = var.spoke_vpcs
  # Values fetched from the Modules
  random_string = module.random.random_string
  routing_mode  = var.vpc_routing_mode
}

module "subnet_ncc_spoke1" {
  source = "../../modules/subnet"

  # Pass Variables
  name         = var.name
  region       = var.spoke1_region
  subnets      = [var.ncc_subnets[0]]
  subnet_cidrs = [var.ncc_subnet_cidrs[0]]
  private_ip_google_access = null
  # Values fetched from the Modules
  random_string = module.random.random_string
  vpcs          = [module.vpc_ncc.vpc_networks[0]]
}

module "subnet_spoke1" {
  source = "../../modules/subnet"

  # Pass Variables
  name         = var.name
  region       = var.spoke1_region
  subnets      = var.spoke1_subnets
  subnet_cidrs = var.spoke1_subnet_cidrs
  private_ip_google_access = null
  # Values fetched from the Modules
  random_string = module.random.random_string
  vpcs          = [module.vpc_ncc.vpc_networks[1]]
}

module "firewall_spoke1" {
  source = "../../modules/firewall"

  # Values fetched from the Modules
  random_string = module.random.random_string
  vpcs          = module.vpc_ncc.vpc_networks
}

# #####################################
# # These are one time configurations #
# #####################################
locals {
  timestamp = formatdate("YYMMDDhhmmss", timestamp())
}

# Compress source code
data "archive_file" "source" {
  type        = "zip"
  source_dir  = "./cfunction"
  output_path = "/tmp/function-${local.timestamp}.zip"
}

# Create bucket that will host the source code
resource "google_storage_bucket" "bucket" {
  name = "${var.name}-${module.random.random_string}-ncc-bucket"
}

# Add source code zip to bucket
resource "google_storage_bucket_object" "zip" {
  # Append file MD5 to force bucket to be recreated
  name   = "source.zip#${data.archive_file.source.output_md5}"
  bucket = google_storage_bucket.bucket.name
  source = data.archive_file.source.output_path
}

# Enable Cloud Functions API
resource "google_project_service" "cf" {
  project = var.project
  service = "cloudfunctions.googleapis.com"

  disable_dependent_services = true
  disable_on_destroy         = false
}

# Enable Cloud Build API
resource "google_project_service" "cb" {
  project = var.project
  service = "cloudbuild.googleapis.com"

  disable_dependent_services = true
  disable_on_destroy         = false
}
#################################
# End - One time configurations #
#################################

# ################
# # Cloud Router #
# ################
resource "google_compute_router" "cloud_router_spoke1" {
  name    = "${var.name}-cr-${module.random.random_string}-spoke1"
  region  = var.spoke1_region
  network = module.vpc_ncc.vpc_networks[0]
  # bgp {
  #   asn = var.cr_bgp_asn_spoke1
  # }
}

# Permissions to invoke the Cloud Function
resource "google_cloudfunctions_function_iam_member" "invoker_spoke1" {
  project        = var.project
  region         = var.spoke1_region
  cloud_function = google_cloudfunctions_function.spoke1_function.name
  role           = "roles/cloudfunctions.invoker"
  # use AllUsers since config-url does not support IAM.
  member = "allUsers"
}

##################
# Cloud Function #
##################
resource "google_cloudfunctions_function" "spoke1_function" {
  name                  = "${var.name}-${module.random.random_string}-spoke1-function"
  description           = "Network Connectivity Center - Spoke1"
  region                = var.spoke1_region
  runtime               = "nodejs14"
  ingress_settings      = "ALLOW_INTERNAL_ONLY"
  available_memory_mb   = 1024
  source_archive_bucket = google_storage_bucket.bucket.name
  source_archive_object = google_storage_bucket_object.zip.name
  trigger_http          = true
  timeout               = 540
  entry_point           = "invokeNCC"

  environment_variables = {
    NAME                         = "spoke1"
    CREDENTIALS_FILE_PATH        = var.credentials_file_path
    PROJECT_ID                   = var.project
    HUB_NAME                     = var.hub_name
    FGT_INSTANCE_SPOKE           = "${var.name}-fgt-${module.random.random_string}-spoke1-fgt-spoke-instance"
    REGION_SPOKE                 = var.spoke1_region
    ZONE_SPOKE                   = var.spoke1_zone
    CLOUD_ROUTER_SPOKE           = google_compute_router.cloud_router_spoke1.name
    VPC_SPOKE                    = module.vpc_ncc.vpc_networks_selflink[0]
    SUBNET_SPOKE                 = module.subnet_ncc_spoke1.subnets_selflink[0]
    CR_BGP_ASN_SPOKE             = var.cr_bgp_asn_spoke1
    CR_BGPPEERS_PEERASN_SPOKE    = var.cr_bgppeers_peerasn_spoke1
    INTERFACE_PRIVATE_IP_1_SPOKE = var.cr_interface1_private_ip_spoke1
    INTERFACE_PRIVATE_IP_2_SPOKE = var.cr_interface2_private_ip_spoke1
  }
}

# Static IP
module "static_ip_spoke1" {
  source = "../../modules/static-ip"

  # Pass Variables
  name   = var.name
  region = var.spoke1_region
  # Values fetched from the Modules
  random_string = module.random.random_string
}

###########################
# Compute Engine Instance #
###########################
module "fgt_spoke1" {
  source = "../../modules/fortigate_ncc_spoke"

  # Pass Variables
  name            = "${var.name}-fgt-${module.random.random_string}-spoke1"
  service_account = var.service_account
  zone            = var.spoke1_zone
  machine         = var.machine
  image           = var.image
  license_file    = var.license_file_1
  function_name   = google_cloudfunctions_function.spoke1_function.https_trigger_url
  # Values fetched from the Modules
  random_string                  = module.random.random_string
  hostname                       = var.hostname_spoke1
  public_vpc_network             = module.vpc_ncc.vpc_networks[0]
  private_vpc_network            = module.vpc_ncc.vpc_networks[1]
  public_subnet                  = module.subnet_ncc_spoke1.subnets[0]
  private_subnet                 = module.subnet_spoke1.subnets[0]
  static_ip                      = module.static_ip_spoke1.static_ip
  cr_interface1_private_ip_spoke = var.cr_interface1_private_ip_spoke1
  cr_interface2_private_ip_spoke = var.cr_interface2_private_ip_spoke1
  cr_bgp_asn_spoke               = var.cr_bgp_asn_spoke1
  cr_bgppeers_peerasn_spoke      = var.cr_bgppeers_peerasn_spoke1
  router_ip_spoke                = var.router_ip_spoke1
  router_id_remote               = var.router_id_remote1
  router_ip_remote               = var.router_ip_remote1
  asn_remote                     = var.asn_remote1
  subnet_cidr_ncc                = var.ncc_subnet_cidrs[0]
  subnet_cidr_spoke              = var.spoke1_subnet_cidrs[0]
  remote_internal_ip_nic0        = google_compute_address.internal_ip_nic0_remote1.address
  remote_internal_ip_nic1        = google_compute_address.internal_ip_nic1_remote1.address
  remote_site_ip                 = module.fgt_remote1.fgt_cluster_ip # Should be the IP-Address of the Remote Site
  ncc_cloud_function             = substr(google_cloudfunctions_function.spoke1_function.https_trigger_url, 8, length(google_cloudfunctions_function.spoke1_function.https_trigger_url))
  public_subnet_gateway          = module.subnet_ncc_spoke1.public_subnet_gateway_address
}

##############
# Remote - 1 #
##############
###########################
# Compute Engine Instance #
###########################
module "remote1_vpc" {
  source = "../../modules/vpc"
  # Pass Variables
  name = var.name
  vpcs = var.remote1_vpcs
  # Values fetched from the Modules
  random_string = module.random.random_string
}

module "subnet_ncc_remote1" {
  source = "../../modules/subnet"

  # Pass Variables
  name         = var.name
  region       = var.spoke1_region
  subnets      = var.remote1_subnets
  subnet_cidrs = var.remote1_subnet_cidrs
  private_ip_google_access = null
  # Values fetched from the Modules
  random_string = module.random.random_string
  vpcs          = module.remote1_vpc.vpc_networks
}

module "firewall" {
  source = "../../modules/firewall"

  # Values fetched from the Modules
  random_string = module.random.random_string
  vpcs          = module.remote1_vpc.vpc_networks
}

# Internal IP
resource "google_compute_address" "internal_ip_nic0_remote1" {
  name         = "${var.name}-fgt-${module.random.random_string}-nic0-remote1"
  subnetwork   = module.subnet_ncc_remote1.subnets[0]
  address_type = "INTERNAL"
  address      = var.internal_ip_nic0_remote1
  region       = var.spoke1_region
}

# Internal IP
resource "google_compute_address" "internal_ip_nic1_remote1" {
  name         = "${var.name}-fgt-${module.random.random_string}-nic1-remote1"
  subnetwork   = module.subnet_ncc_remote1.subnets[1]
  address_type = "INTERNAL"
  address      = var.internal_ip_nic1_remote1
  region       = var.spoke1_region
}

module "fgt_remote1" {
  source = "../../modules/fortigate_ncc_remote"

  # Pass Variables
  name            = "${var.name}-fgt-${module.random.random_string}-remote1"
  service_account = var.service_account
  zone            = var.spoke1_zone
  machine         = var.machine
  image           = var.image
  license_file    = var.license_file_3
  # Values fetched from the Modules
  random_string             = module.random.random_string
  hostname                  = var.hostname_remote1
  public_vpc_network        = module.remote1_vpc.vpc_networks[0]
  private_vpc_network       = module.remote1_vpc.vpc_networks[1]
  public_subnet             = module.subnet_ncc_remote1.subnets[0]
  private_subnet            = module.subnet_ncc_remote1.subnets[1]
  static_ip                 = module.static_ip_remote1.static_ip
  public_subnet_gateway     = module.subnet_ncc_remote1.public_subnet_gateway_address
  asn_remote                = var.asn_remote1
  cr_bgppeers_peerasn_spoke = var.cr_bgppeers_peerasn_spoke1
  router_ip_remote          = var.router_ip_remote1
  router_ip_spoke           = var.router_ip_spoke1
  spoke_site_ip             = module.static_ip_spoke1.static_ip # Should be the IP-Address of the Spoke Site
  subnet_cidr_remote        = var.remote1_subnet_cidrs[1]
  remote_internal_ip_nic0   = google_compute_address.internal_ip_nic0_remote1.address
  remote_internal_ip_nic1   = google_compute_address.internal_ip_nic1_remote1.address
  subnet_cidr_ncc           = var.ncc_subnet_cidrs[0]
  subnet_cidr_spoke         = var.spoke1_subnet_cidrs[0]
}

# Static IP
module "static_ip_remote1" {
  source = "../../modules/static-ip"

  # Pass Variables
  name   = "${var.name}-static-ip-${module.random.random_string}-remote1"
  region = var.spoke1_region
  # Values fetched from the Modules
  random_string = module.random.random_string
}

#############
# Spoke - 2 #
#############

module "subnet_ncc_spoke2" {
  source = "../../modules/subnet"

  # Pass Variables
  name         = var.name
  region       = var.spoke2_region
  subnets      = [var.ncc_subnets[1]]
  subnet_cidrs = [var.ncc_subnet_cidrs[1]]
  private_ip_google_access = null
  # Values fetched from the Modules
  random_string = module.random.random_string
  vpcs          = [module.vpc_ncc.vpc_networks[0]]
}

module "subnet_spoke2" {
  source = "../../modules/subnet"

  # Pass Variables
  name         = var.name
  region       = var.spoke2_region
  subnets      = var.spoke2_subnets
  subnet_cidrs = var.spoke2_subnet_cidrs
  private_ip_google_access = null
  # Values fetched from the Modules
  random_string = module.random.random_string
  vpcs          = [module.vpc_ncc.vpc_networks[2]]
}

################
# Cloud Router #
################
resource "google_compute_router" "cloud_router_spoke2" {
  name    = "${var.name}-cr-${module.random.random_string}-spoke2"
  region  = var.spoke2_region
  network = module.vpc_ncc.vpc_networks[0]
  # bgp {
  #   asn = var.cr_bgp_asn_spoke2
  # }
}

# Permissions to invoke the Cloud Function
resource "google_cloudfunctions_function_iam_member" "invoker_spoke2" {
  project        = var.project
  region         = var.spoke2_region
  cloud_function = google_cloudfunctions_function.spoke2_function.name
  role           = "roles/cloudfunctions.invoker"
  # use AllUsers since config-url does not support IAM.
  member = "allUsers"
}

##################
# Cloud Function #
##################
resource "google_cloudfunctions_function" "spoke2_function" {
  depends_on            = [google_cloudfunctions_function.spoke1_function]
  name                  = "${var.name}-${module.random.random_string}-spoke2-function"
  description           = "Network Connectivity Center - Spoke2"
  region                = var.spoke2_region
  runtime               = "nodejs14"
  ingress_settings      = "ALLOW_INTERNAL_ONLY"
  available_memory_mb   = 1024
  source_archive_bucket = google_storage_bucket.bucket.name
  source_archive_object = google_storage_bucket_object.zip.name
  trigger_http          = true
  timeout               = 540
  entry_point           = "invokeNCC"

  environment_variables = {
    NAME                         = "spoke2"
    CREDENTIALS_FILE_PATH        = var.credentials_file_path
    PROJECT_ID                   = var.project
    HUB_NAME                     = var.hub_name
    FGT_INSTANCE_SPOKE           = "${var.name}-fgt-${module.random.random_string}-spoke2-fgt-spoke-instance"
    REGION_SPOKE                 = var.spoke2_region
    ZONE_SPOKE                   = var.spoke2_zone
    CLOUD_ROUTER_SPOKE           = google_compute_router.cloud_router_spoke2.name
    VPC_SPOKE                    = module.vpc_ncc.vpc_networks_selflink[0]
    SUBNET_SPOKE                 = module.subnet_ncc_spoke2.subnets_selflink[0]
    CR_BGP_ASN_SPOKE             = var.cr_bgp_asn_spoke2
    CR_BGPPEERS_PEERASN_SPOKE    = var.cr_bgppeers_peerasn_spoke2
    INTERFACE_PRIVATE_IP_1_SPOKE = var.cr_interface1_private_ip_spoke2
    INTERFACE_PRIVATE_IP_2_SPOKE = var.cr_interface2_private_ip_spoke2
  }
}

# Static IP
module "static_ip_spoke2" {
  source = "../../modules/static-ip"

  # Pass Variables
  name   = "${var.name}-static-ip-${module.random.random_string}-spoke2"
  region = var.spoke2_region
  # Values fetched from the Modules
  random_string = module.random.random_string
}

###########################
# Compute Engine Instance #
###########################
module "fgt_spoke2" {
  source = "../../modules/fortigate_ncc_spoke"

  # Pass Variables
  name            = "${var.name}-fgt-${module.random.random_string}-spoke2"
  service_account = var.service_account
  zone            = var.spoke2_zone
  machine         = var.machine
  image           = var.image
  license_file    = var.license_file_2
  function_name   = google_cloudfunctions_function.spoke2_function.https_trigger_url
  # Values fetched from the Modules
  random_string                  = module.random.random_string
  hostname                       = var.hostname_spoke2
  public_vpc_network             = module.vpc_ncc.vpc_networks[0]
  private_vpc_network            = module.vpc_ncc.vpc_networks[2]
  public_subnet                  = module.subnet_ncc_spoke2.subnets[0]
  private_subnet                 = module.subnet_spoke2.subnets[0]
  static_ip                      = module.static_ip_spoke2.static_ip
  cr_interface1_private_ip_spoke = var.cr_interface1_private_ip_spoke2
  cr_interface2_private_ip_spoke = var.cr_interface2_private_ip_spoke2
  cr_bgp_asn_spoke               = var.cr_bgp_asn_spoke2
  cr_bgppeers_peerasn_spoke      = var.cr_bgppeers_peerasn_spoke2
  router_ip_spoke                = var.router_ip_spoke2
  router_ip_remote               = var.router_ip_remote2
  router_id_remote               = var.router_id_remote2
  asn_remote                     = var.asn_remote2
  subnet_cidr_ncc                = var.ncc_subnet_cidrs[1]
  subnet_cidr_spoke              = var.spoke2_subnet_cidrs[0]
  remote_internal_ip_nic0        = google_compute_address.internal_ip_nic0_remote2.address
  remote_internal_ip_nic1        = google_compute_address.internal_ip_nic1_remote2.address
  remote_site_ip                 = module.fgt_remote2.fgt_cluster_ip # Should be the IP-Address of the Remote Site - 2
  ncc_cloud_function             = substr(google_cloudfunctions_function.spoke2_function.https_trigger_url, 8, length(google_cloudfunctions_function.spoke2_function.https_trigger_url))
  public_subnet_gateway          = module.subnet_spoke2.public_subnet_gateway_address
}

##############
# Remote - 2 #
##############
###########################
# Compute Engine Instance #
###########################
module "remote2_vpc" {
  source = "../../modules/vpc"
  # Pass Variables
  name = var.name
  vpcs = var.remote2_vpcs
  # Values fetched from the Modules
  random_string = module.random.random_string
}

module "subnet_ncc_remote2" {
  source = "../../modules/subnet"

  # Pass Variables
  name         = var.name
  region       = var.spoke2_region
  subnets      = var.remote2_subnets
  subnet_cidrs = var.remote2_subnet_cidrs
  private_ip_google_access = null
  # Values fetched from the Modules
  random_string = module.random.random_string
  vpcs          = module.remote2_vpc.vpc_networks
}

module "firewall_remote2" {
  source = "../../modules/firewall"

  # Values fetched from the Modules
  random_string = module.random.random_string
  vpcs          = module.remote2_vpc.vpc_networks
}

###############
# Internal IP #
###############
resource "google_compute_address" "internal_ip_nic0_remote2" {
  name         = "${var.name}-fgt-${module.random.random_string}-nic0-remote2"
  subnetwork   = module.subnet_ncc_remote2.subnets[0]
  address_type = "INTERNAL"
  address      = var.internal_ip_nic0_remote2
  region       = var.spoke2_region
}

resource "google_compute_address" "internal_ip_nic1_remote2" {
  name         = "${var.name}-fgt-${module.random.random_string}-nic1-remote2"
  subnetwork   = module.subnet_ncc_remote2.subnets[1]
  address_type = "INTERNAL"
  address      = var.internal_ip_nic1_remote2
  region       = var.spoke2_region
}

module "fgt_remote2" {
  source = "../../modules/fortigate_ncc_remote"

  # Pass Variables
  name            = "${var.name}-fgt-${module.random.random_string}-remote2"
  service_account = var.service_account
  zone            = var.spoke2_zone
  machine         = var.machine
  image           = var.image
  license_file    = var.license_file_4
  # Values fetched from the Modules
  random_string             = module.random.random_string
  hostname                  = var.hostname_remote2
  public_vpc_network        = module.remote2_vpc.vpc_networks[0]
  private_vpc_network       = module.remote2_vpc.vpc_networks[1]
  public_subnet             = module.subnet_ncc_remote2.subnets[0]
  private_subnet            = module.subnet_ncc_remote2.subnets[1]
  static_ip                 = module.static_ip_remote2.static_ip
  public_subnet_gateway     = module.subnet_ncc_remote2.public_subnet_gateway_address
  asn_remote                = var.asn_remote2
  cr_bgppeers_peerasn_spoke = var.cr_bgppeers_peerasn_spoke2
  router_ip_remote          = var.router_ip_remote2
  router_ip_spoke           = var.router_ip_spoke2
  spoke_site_ip             = module.static_ip_spoke2.static_ip # Should be the IP-Address of the Spoke - 2
  subnet_cidr_remote        = var.remote2_subnet_cidrs[1]
  remote_internal_ip_nic0   = google_compute_address.internal_ip_nic0_remote2.address
  remote_internal_ip_nic1   = google_compute_address.internal_ip_nic1_remote2.address
  subnet_cidr_ncc           = var.ncc_subnet_cidrs[1]
  subnet_cidr_spoke         = var.spoke2_subnet_cidrs[0]
}

# Static IP
module "static_ip_remote2" {
  source = "../../modules/static-ip"

  # Pass Variables
  name   = "${var.name}-static-ip-${module.random.random_string}-remote2"
  region = var.spoke2_region
  # Values fetched from the Modules
  random_string = module.random.random_string
}
