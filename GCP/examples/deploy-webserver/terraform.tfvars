credentials_file_path   = "<CREDENTIALS>"
project                 = "<GCP_PROJECT>"
name                    = "terraform"
region                  = "us-central1"
zone                    = "us-central1-c"
machine                 = "n1-standard-4"
image                   = "projects/ubuntu-os-cloud/global/images/ubuntu-1604-xenial-v20200702"
# VPCs
vpcs                    = ["public-vpc"]
# subnet module
subnets                 = ["public-subnet"]
subnet_cidrs            = ["172.19.2.0/24"]
