credentials_file_path = "<CREDENTIALS>"
service_account       = "<SERVICE_ACCOUNT_EMAIL>"
project               = "<GCP_PROJECT>"
name                  = "terraform-site-2-site"
region                = "us-central1"
zone                  = "us-central1-c"
# VPCs
vpcs             = ["public-vpc"]
vpc_routing_mode = "GLOBAL"
# subnet module
subnets      = ["public-subnet"]
subnet_cidrs = ["172.18.0.0/24"]
# VPN
shared_secret = "fortinet"
# Cloud Router
cr_asn                       = 64514
cr_interface_ip_range        = ["169.254.0.1/30", "169.254.1.1/30"]
cr_peer_ip_address           = ["169.254.0.2", "169.254.1.2"]
cr_peer_asn                  = 64515
cr_advertised_route_priority = 100
# FGT in Other Cloud
fgt_ip = "<CLOUD_FGT_ID>"
