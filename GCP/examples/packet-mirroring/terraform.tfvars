credentials_file_path       = "<credentials_file_path>"
service_account             = "<service_account_email>"
project                     = "<project>"
name                        = "terraform"
region                      = "us-central1"
zone                        = "us-central1-c"
fgt_machine                 = "n1-standard-4"
tag                         = "packet-mirroring"
admin_port                  = 8443
# FortiGate Image name
# 6.4.2 payg is projects/fortigcp-project-001/global/images/fortinet-fgtondemand-642-20200810-001-w-license
# 6.4.2 byol is projects/fortigcp-project-001/global/images/fortinet-fgt-642-20200810-001-w-license
image                       = "projects/fortigcp-project-001/global/images/fortinet-fgtondemand-642-20200810-001-w-license"
ubuntu_image                = "ubuntu-os-cloud/ubuntu-2004-lts"
ubuntu_machine              = "n1-standard-2"
instance_count              = 2
# VPCs
vpcs                        = ["peering-vpc", "public-vpc", "private-vpc", "mirroring-vpc"]
# Subnet
subnets                     = ["peering-vpc", "public-vpc", "private-vpc", "mirroring-vpc"]
subnet_cidrs                = ["172.16.0.0/24", "192.168.24.0/24", "192.168.25.0/24", "192.168.26.0/24"]
# Internal Load Balancer
int_check_interval_sec          = 3
int_timeout_sec                 = 2
int_port                        = 22
