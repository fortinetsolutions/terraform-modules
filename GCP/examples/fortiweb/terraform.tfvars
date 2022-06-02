credentials_file_path    = "<CREDENTIALS>"
project                  = "<GCP_PROJECT>"
service_account          = "<SERVICE_ACCOUNT_EMAIL>"
name                    = "terraform-fweb"
region                  = "us-central1"
zone                    = "us-central1-c"
machine                 = "n2-standard-2"
# FortiWeb Image name
image                   = "<IMAGE>"
license_file            = null
# VPCs
vpcs                    = ["untrust-vpc", "trust-vpc"]
# subnet module
subnets                 = ["untrust-subnet", "trust-subnet"]
subnet_cidrs            = ["10.0.1.0/24", "10.0.2.0/24"]
