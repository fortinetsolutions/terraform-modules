credentials_file_path    = "<CREDENTIALS>"
project                  = "<GCP_PROJECT>"
service_account          = "<SERVICE_ACCOUNT_EMAIL>"
name                     = "terraform-ha-ap"
region                   = "us-central1"
zone                     = ["us-central1-a", "us-central1-c"]
machine                  = "n2-standard-4"
image                    = "<IMAGE>"
license_file             = "<LICENSE_FILE>"
license_file_2           = "<LICENSE_FILE>"
active_port1_ip          = "172.14.0.2"
active_port1_mask        = "24"
active_port2_ip          = "172.14.1.2"
active_port2_mask        = "24"
active_port3_ip          = "172.14.2.2"
active_port3_mask        = "24"
active_port4_ip          = "172.14.3.2"
active_port4_mask        = "24"
passive_port1_ip         = "172.14.0.3"
passive_port1_mask       = "24"
passive_port2_ip         = "172.14.1.3"
passive_port2_mask       = "24"
passive_port3_ip         = "172.14.2.3"
passive_port3_mask       = "24"
passive_port4_ip         = "172.14.3.3"
passive_port4_mask       = "24"
mgmt_gateway             = "172.14.3.1"
mgmt_mask                = "255.255.255.0"
# route module
next_hop_ip              = "172.14.1.2"
# subnet module
subnets                  = ["public-subnet", "private-subnet", "sync-subnet", "mgmt-subnet"]
subnet_cidrs             = ["172.14.0.0/24", "172.14.1.0/24", "172.14.2.0/24", "172.14.3.0/24"]
subnet_private_ip_google_access = [true, false, false, false]
# VPCs
vpcs                     = ["public-vpc", "private-vpc", "sync-vpc", "mgmt-vpc"]
