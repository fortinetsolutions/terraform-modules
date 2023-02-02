project                 = "<GCP_PROJECT>"
name                    = "terraform-fweb-qwiklab"
region                  = "us-central1"
zone                    = "us-central1-c"
machine                 = "n2-standard-4"
# FortiWeb Image name
# image                   = "<IMAGE>"
image                   = "fwb-703-payg-09122022-002-w-license"
license_file            = null
ubuntu_image            = "projects/ubuntu-os-cloud/global/images/ubuntu-1604-xenial-v20200702"
# VPCs
vpcs                    = ["untrust-vpc", "trust-vpc", "mgmt-vpc"]
# subnet module
subnets                 = ["untrust-subnet", "trust-subnet", "mgmt-subnet"]
subnet_cidrs            = ["10.10.1.0/24", "10.10.2.0/24", "10.10.3.0/24"]
##########
juice_shop_image_name   = "bkimminich/juice-shop"
juice_shop_machine      = "n1-standard-1"
