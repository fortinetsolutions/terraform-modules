project                 = "<GCP_PROJECT>"
name                    = "qwiklabs-webserver"
region                  = "us-central1"
zone                    = "us-central1-c"
machine                 = "n1-standard-1"
# https://cloud.google.com/compute/docs/images/os-details#ubuntu_lts
image                   = "projects/ubuntu-os-cloud/global/images/ubuntu-1604-xenial-v20200702"
# VPCs
vpcs                    = ["public-vpc"]
# subnet module
subnets                 = ["public-subnet"]
subnet_cidrs            = ["172.29.1.0/24"]