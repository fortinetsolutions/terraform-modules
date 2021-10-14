credentials_file_path       = "<CREDENTIALS>"
service_account             = "<SERVICE-ACCOUNT>"
project                     = "<PROJECTID>"
name                        = "terraform-fmg"
region                      = "us-central1"
zone                        = "us-central1-c"
machine                     = "n1-standard-4"
# FortiManager Image name
# 6.4.4 byol is projects/fortigcp-project-001/global/images/fortinet-fmg-644-20201217-001-w-license
image                       = "<IMAGE>"
license_file                = "<LICENSE_FILE>"
# VPCs
vpcs                        = ["public-vpc"]
# subnet module
subnets                     = ["public-subnet"]
subnet_cidrs                = ["172.18.0.0/24"]
