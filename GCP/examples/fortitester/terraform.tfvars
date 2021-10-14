credentials_file_path       = "<CREDENTIALS>"
service_account             = "<SERVICE-ACCOUNT>"
project                     = "<PROJECTID>"
name                        = "terraform-fortitester"
region                      = "us-central1"
zone                        = "us-central1-c"
machine                     = "n1-standard-4"
# FortiTester Image name
image                       = "<IMAGE>"
# VPCs
vpcs                        = ["fts-mgmt-vpc", "fts-traffic-port1-vpc", "fts-traffic-port2-vpc"]
# subnet module
subnets                     = ["fts-mgmt-subnet", "fts-traffic-port1-subnet", "fts-traffic-port2-subnet"]
subnet_cidrs                = ["10.2.3.0/24", "10.2.4.0/24", "10.2.5.0/24"]
