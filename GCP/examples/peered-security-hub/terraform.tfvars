credentials_file_path    = "<CREDENTIALS>"
project                  = "<GCP_PROJECT>"
service_account          = "<SERVICE_ACCOUNT_EMAIL>"
name                     = "peered-hub-spoke"
region                   = "us-central1"
zone                     = "us-central1-c"
machine                  = "n2-standard-4"
# FortiGate Image name
image                    = "<IMAGE>"
license_file             = null
license_file_2           = null
active_port1_ip          = "172.30.0.2"
active_port1_mask        = "24"
active_port2_ip          = "172.30.1.2"
active_port2_mask        = "24"
active_port3_ip          = "172.30.2.2"
active_port3_mask        = "24"
active_port4_ip          = "172.30.3.2"
active_port4_mask        = "24"
passive_port1_ip         = "172.30.0.3"
passive_port1_mask       = "24"
passive_port2_ip         = "172.30.1.3"
passive_port2_mask       = "24"
passive_port3_ip         = "172.30.2.3"
passive_port3_mask       = "24"
passive_port4_ip         = "172.30.3.3"
passive_port4_mask       = "24"
mgmt_gateway             = "172.30.3.1"
mgmt_mask                = "255.255.255.0"
# route module
next_hop_ip              = "172.30.1.2"
next_hop_gateway         = "default-internet-gateway"
tags                     = ["ha-instance"]
# subnet module
subnets                  = ["public-subnet", "private-subnet", "sync-subnet", "mgmt-subnet", "frontend-subnet"]
subnet_cidrs             = ["172.30.0.0/24", "172.30.1.0/24", "172.30.2.0/24", "172.30.3.0/24", "192.168.1.0/24"]
subnet_private_ip_google_access = [true, false, false, false, false]
# VPCs
vpcs                     = ["public-vpc", "private-vpc", "sync-vpc", "mgmt-vpc", "frontend-vpc"]
# WebServer
webserver_machine        = "n1-standard-4"
ubuntu_image             = "projects/ubuntu-os-cloud/global/images/ubuntu-1804-bionic-v20210825"
