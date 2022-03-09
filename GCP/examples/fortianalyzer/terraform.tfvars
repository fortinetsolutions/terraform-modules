credentials_file_path       = "<CREDENTIALS>"
service_account             = "<SERVICE-ACCOUNT>"
project                     = "<PROJECTID>"
name                        = "terraform-faz"
region                      = "us-central1"
zone                        = "us-central1-c"
machine                     = "n2-standard-2"
image                       = "<IMAGE>"
# license_file              = null
# VPCs
vpcs                        = ["public-vpc"]
# subnet module
subnets                     = ["public-subnet"]
subnet_cidrs                = ["172.18.0.0/24"]
