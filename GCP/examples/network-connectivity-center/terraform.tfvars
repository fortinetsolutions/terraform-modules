credentials_file_path = "<CREDENTIALS>"
service_account       = "<SERVICE_ACCOUNT_EMAIL>"
project               = "<GCP_PROJECT>"
name                  = "terraform-ncc"
spoke1_region         = "us-central1"
spoke2_region         = "us-west2"
spoke1_zone           = "us-central1-c"
spoke2_zone           = "us-west2-a"
machine               = "n1-standard-2"
# FortiGate Image name
image          = "<FGT_IMAGE>"
license_file_1 = "<LICENSE_FILE_1>"
license_file_2 = "<LICENSE_FILE_2>"
license_file_3 = "<LICENSE_FILE_3>"
license_file_4 = "<LICENSE_FILE_4>"
# VPCs
spoke_vpcs       = ["ncc-vpc", "spoke1-vpc", "spoke2-vpc"]
remote1_vpcs     = ["remote1-public-vpc", "remote1-private-vpc"]
remote2_vpcs     = ["remote2-public-vpc", "remote2private-vpc"]
vpc_routing_mode = "GLOBAL"
# subnet module
ncc_subnets     = ["ncc-spoke1-public-subnet", "ncc-spoke2-public-subnet"]
spoke1_subnets  = ["spoke1-public-subnet"]
spoke2_subnets  = ["spoke2-public-subnet"]
remote1_subnets = ["remote1-public-subnet", "remote1-private-subnet"]
remote2_subnets = ["remote2-public-subnet", "remote2-private-subnet"]
# CIDRs
ncc_subnet_cidrs     = ["172.16.0.0/24", "192.168.105.0/24"]
spoke1_subnet_cidrs  = ["172.16.10.0/24"]
spoke2_subnet_cidrs  = ["192.168.115.0/24"]
remote1_subnet_cidrs = ["172.18.0.0/24", "172.18.1.0/24"]
remote2_subnet_cidrs = ["192.168.225.0/24", "192.168.226.0/24"]
# Firewall module
fw_ingress = ["public-fw-ingress", "private-fw-ingress"]
fw_egress  = ["public-fw-egress", "private-fw-egress"]
# NCC
hub_name = "terraform-hub-name-bootstrap"
# Spoke-1
hostname_spoke1                 = "Central1-Spoke"
cr_bgp_asn_spoke1               = 64514
cr_bgppeers_peerasn_spoke1      = 65001
cr_interface1_private_ip_spoke1 = "172.16.0.101"
cr_interface2_private_ip_spoke1 = "172.16.0.102"
router_ip_spoke1                = "169.254.110.1" # Interface-Tunnel IP
# Remote-Site-1
hostname_remote1         = "Central1-Remote"
router_ip_remote1        = "169.254.110.2"
router_id_remote1        = "169.250.221.254"
asn_remote1              = "7224"
internal_ip_nic0_remote1 = "172.18.0.2"
internal_ip_nic1_remote1 = "172.18.1.2"
# Spoke-2
hostname_spoke2                 = "West2-Spoke"
cr_bgp_asn_spoke2               = 65005
cr_bgppeers_peerasn_spoke2      = 7252
cr_interface1_private_ip_spoke2 = "192.168.105.101"
cr_interface2_private_ip_spoke2 = "192.168.105.102"
router_ip_spoke2                = "169.254.120.1" # Interface-Tunnel IP
# Remote-Site-2
hostname_remote2         = "West2-Remote"
router_ip_remote2        = "169.254.120.2"
router_id_remote2        = "169.250.221.253"
asn_remote2              = "7225"
internal_ip_nic0_remote2 = "192.168.225.2"
internal_ip_nic1_remote2 = "192.168.226.2"

