project                 = "<GCP_PROJECT>"
name                    = "qwiklabs-webserver"
region                  = "us-central1"
zone                    = "us-central1-c"
machine                 = "n2-standard-2"
# https://cloud.google.com/compute/docs/images/os-details#ubuntu_lts
image                   = "projects/ubuntu-os-cloud/global/images/ubuntu-1604-xenial-v20200702"
# VPCs
vpcs                    = ["public-vpc", "private-vpc"]
# subnet module
subnets                 = ["public-subnet", "private-subnet"]
subnet_cidrs            = ["172.29.1.0/24", "172.29.2.0/24"]